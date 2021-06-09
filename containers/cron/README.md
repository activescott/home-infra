# cron container

A container to run cron jobs. Notably a way to renew letsencrypt certificates.

## cron job setup

I did quite a bit of research on ways to set up cron via docker and found [this article](https://devopsheaven.com/cron/docker/alpine/linux/2017/10/30/run-cron-docker-alpine.html) to be an ideal explanation of an elegant solution for what I liked.

Essentially alpine includes the following directories, where you can put a shell script in each directory and cron will run it accordingly. You can always modify the crontab file just like any other system for more control, but these directories handle most use cases:

    /etc/periodic/hourly
    /etc/periodic/daily
    /etc/periodic/15min
    /etc/periodic/monthly
    /etc/periodic/weekly

## Certificates with Lets Encrypt & certbot

For certificates, I let cron container periodically kick off a job in a separate docker container containing certbot. I launch the second docker container _on the host's_ docker daemon by mounting the host's Docker Daemon's `/var/run/docker.sock` as a volume ([this article explained](https://devopscube.com/run-docker-in-docker/) this best for me). THis prevnts the need for the cron container from having to install certbot or whatever other dependencies may be needed for other jobs. The exact file for launching certbot is in `./cron_tasks_folder/weekly/renew-certificates.sh`.

### Certificates Folder Structure: Sharing Certificates between Containers

Both the cerbot container and the containers using certs (such as home assistant) mount the `/share/CACHEDEV1_DATA/app-data/letsencrypt/` directory. cerbot puts it certs there by mounting that volume to `/etc/letsencrypt/`. [Certbot puts generated keys and issued certificates in `/etc/letsencrypt/live/$domain`, where $domain is the certificate name](https://certbot.eff.org/docs/using.html#where-are-my-certificates)). Other containers mount that same directory (as read-only) and pull their cert from there.

> NOTE: The permissions certbot uses are quite restrictive here and may cause issues. They can be relaxed and certbot docs explain more [here](https://certbot.eff.org/docs/using.html#where-are-my-certificates).

## Publishing activescott/cron Docker Hub

The `activescott/cron` container is on dockerhub at https://hub.docker.com/repository/docker/activescott/cron
A manual build to build the container from the Dockerfile source in the `main` branch in this repo can be published by clicking on "Trigger" button for the `latest` dockerhub tag at https://hub.docker.com/repository/docker/activescott/cron/builds

Update `containers/cron/cron.Dockerfile` and use a git tag on the commit with a tag that meets the regex `^cron-([0-9.]+)` and dockerhub should detect the git tag and automatically publish an image from that commit with the tag `release-<version>`. For example the git tag `cron-1.0.0` should result in a docker tag `cron-1.0.0` and a valid image reference from docker-compose of `activescott/cron:release-1.0.0`.
