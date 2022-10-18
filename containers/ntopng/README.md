# ntopng

This is my ntopng container. I use it to monitor network activity at home and get alerts about suspicious activity.

## Redis Errors due to Ownership After ntopng Container Update

It appears that after this container is updated by watchtower redis fails to work again due to some persistance issues. I'm not sure what causes it but erros look like this:

```
30/Sep/2022 18:28:16 [Redis.cpp:507] ERROR: MISCONF Redis is configured to save RDB snapshots, but it is currently not able to persist on disk. Commands that may modify the data set are disabled, because this instance is configured to report errors during writes if RDB snapshotting fails (stop-writes-on-bgsave-error option). Please check the Redis logs for details about the RDB error.
```

Most recently I noticed it was resolved _temporarily_ by stopping the container and restarting it :/ A few minutes later ntopng failed again with the same error in `docker logs`.

Redis logs show:
```
$ docker exec -it ntopng tail -f /var/log/redis/redis-server.log
...
15:M 30 Sep 2022 19:15:30.089 * 10 changes in 300 seconds. Saving...
15:M 30 Sep 2022 19:15:30.089 * Background saving started by pid 131
131:C 30 Sep 2022 19:15:30.089 # Failed opening the RDB file dump.rdb (in server root dir /var/lib/redis) for saving: Permission denied
15:M 30 Sep 2022 19:15:30.189 # Background saving error

```

I also checked the redis uid in that container with `docker exec -it ntopng /usr/bin/id redis` and it was as follows `uid=102(redis) gid=103(redis) groups=103(redis)`.

Yet the permissions of files in /var/lib/redis are:
```
$ ll /var/lib/redis
total 60
drwxr-xr-x 2 messagebus messagebus  4096 Sep 17 06:38 ./
drwxr-xr-x 1 root       root        4096 Sep 30 11:06 ../
-rw-rw-r-- 1 messagebus messagebus 46427 Sep 17 06:38 dump.rdb
```

Changing the ownership back to redis fixed it in redis logs:
```
$ chown -R redis:redis /var/lib/redis

$ ll /var/lib/redis
total 76
drwxr-xr-x 2 redis redis  4096 Sep 30 19:15 ./
drwxr-xr-x 1 root  root   4096 Sep 30 11:06 ../
-rw-rw-r-- 1 redis redis 46427 Sep 17 06:38 dump.rdb
-rw-rw---- 1 redis redis 15371 Sep 30 19:15 temp-133.rdb


$ docker exec -it ntopng tail -f /var/log/redis/redis-server.log
...
15:M 30 Sep 2022 19:15:36.000 * 10 changes in 300 seconds. Saving...
15:M 30 Sep 2022 19:15:36.001 * Background saving started by pid 133
133:C 30 Sep 2022 19:15:36.121 * DB saved on disk
133:C 30 Sep 2022 19:15:36.122 * RDB: 0 MB of memory used by copy-on-write
15:M 30 Sep 2022 19:15:36.202 * Background saving terminated with success

```

but the same erorr in docker logs... trying a restart with:
```
docker restart  ntopng ; docker logs -f ntopng
```


🤷‍♂️

## Losing Configuration Settings Issue (Persistence)

I had a problem where initially config changes I was making weren't being saved and even the admin password I set wouldn't be saved. Specific configuration I noticed I was losing:

1. The admin user's default password!
2. **Local Broadcast Domain Hosts Identifier** at https://bitbox.activescott.com:3101/lua/if_stats.lua?ifid=0&page=config should be **MAC Address**
3. DHCP Ranges at https://bitbox.activescott.com:3101/lua/if_stats.lua?page=dhcp (there should be one!)

I am mounting the `/var/lib/ntopng/` volume to a persistant store and saw it changing stuff there, but it still wasn't saving things. After reflecting on this and realizing they are using redis, I checked [their redis config](https://github.com/ntop/docker-ntop/blob/master/Dockerfile.ntopng) and they don't explicitly configure redis to save. The [redis defaults](https://redis.io/docs/manual/config/) are pretty infrequent saves:

> Unless specified otherwise, by default Redis will save the DB:
>
> - After 3600 seconds (an hour) if at least 1 key changed
> - After 300 seconds (5 minutes) if at least 100 keys changed
> - After 60 seconds if at least 10000 keys changed

Seemed reasonable that they aren't triggering a save for an hour.

So I forced a save of redis like this:

```
# check the last redis save time (note redis-cli is in the container)
$ docker exec -it ntopng redis-cli LASTSAVE

# ask redis to save in the background:
$ docker exec -it ntopng redis-cli BGSAVE
Background saving started

# check the last save time from redis after a few seconds or so and it should be different:
$ docker exec -it ntopng redis-cli LASTSAVE
```

After doing the above I _still_ had some problems intermittently with config getting lost.

### SOLVED: Redis Logs & Redis Failing to Write Dump due to Permissions

I found a redis file at `/var/lib/redis/dump.rdb` which is [apparently where redis saves the files _you can manually call the SAVE or BGSAVE commands_](https://redis.io/docs/manual/persistence/) so I started mounting `/var/lib/redis` to a persistent volume as well despite it not being documented to do so by ntopng.

Then I noticed an error coming out of ntopng via `docker logs -f ntopng` about redis being in an unhealty state and all writes being prevented.

Got redis logs at `docker exec -it ntopng tail -f /var/log/redis/redis-server.log`

Redis failed to write the dump upon mounting due to permissions (redis switches to running as the redis user not the root user that docker was using). I did the following to fix that (within the container, so after a `docker exec -it ntopng /bin/sh`:

```
chown -R redis:redis /var/lib/redis
```

Then I could restart the container (by changing docker-compose definition) and see this in the redis log `DB loaded from disk: 0.000 seconds`. I did several restarts after this (and doing the `BGSAVE` above) and didn't see the problem anymore.

### Some tools that helped me diagnose:

#### Querying Redis

ntopng stores most things in redis. So knowing how to query redis is helpful to understand things...

I also found I could some of important redis keys using [the README.users doc](https://github.com/ntop/ntopng/blob/dev/doc/README.users) on their github repo. So now I can do `docker exec -it ntopng redis-cli GET ntopng.user.admin.password` to make sure that the admin password is set (it is `(nil)` on a fresh instance).

Interestingly this leads to other interesting redis queries like `docker exec -it ntopng redis-cli KEYS ntopng.prefs.*`, etc...

A pref I seemed to lose periodically was `ntopng.prefs.ifid_%u.serialize_local_broadcast_hosts_as_macs`

So

```
docker exec -it ntopng redis-cli GET ntopng.prefs.ifid_%u.serialize_local_broadcast_hosts_as_macs
```

The [Device Applications policies](https://www.ntop.org/guides/ntopng/advanced_features/device_protocols.html?highlight=applications) /do/ appear to be in redis. It is saved at https://github.com/ntop/ntopng/blob/49bdd32ce08d57971debb74ec9206fc4bbae2edd/scripts/lua/modules/presets_utils.lua#L228 by the UI at https://github.com/ntop/ntopng/blob/49bdd32ce08d57971debb74ec9206fc4bbae2edd/scripts/lua/inc/edit_presets.lua#L74 Can find their keys with `docker exec -it ntopng redis-cli KEYS ntopng.prefs.device_policies*`

Another preference I was losing was **DHCP interface ranges** (https://bitbox.activescott.com:3101/lua/if_stats.lua?page=dhcp). Their key is `ntopng.prefs.ifid_%u.dhcp_ranges` where %u is an interface id (0 for one interface):

To query that key you can do:

```
docker exec -it ntopng redis-cli GET ntopng.prefs.ifid_0.dhcp_ranges
```

## References

- Overview: https://www.ntop.org/products/traffic-analysis/ntop/
- Source: https://github.com/ntop/ntopng/
  - https://github.com/ntop/docker-ntop
    - `NTOP_CONFIG` environment variable: https://github.com/ntop/docker-ntop#ntop_config-environment-variable
- Image: https://hub.docker.com/r/ntop/ntopng/ (note use of stable over latest tag)
- Docs: https://www.ntop.org/guides/ntopng/
- couple gems here: https://www.ntop.org/ntop/best-practices-for-using-ntop-tools-on-containers/
- example from someone else doing their own dockerfile/compose setup: https://shownotes.opensourceisawesome.com/ntopng-network-analysis-dashboard/

### Configuring Custom Applications

TLDR; create `/var/lib/ntopng/protos.txt` and fill it out like [this example](https://raw.githubusercontent.com/ntop/nDPI/dev/example/protos.txt). Then add add the following option to the startup of the app:

```
--ndpi-protocols=/var/lib/ntopng/protos.txt
```

https://www.ntop.org/guides/ntopng/web_gui/categories.html#custom-applications
