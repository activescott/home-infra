# nextcloud in k8s

This is a nextcloud container set up in kubernetes using kustomize and minimal elements from the official nextcloud helm chart.

## Notes

### Running `occ`

To run the nextcloud `occ` maintenance command in the container is a bit of a trick. You need to use su to specify the user www-data and that user doesn't have a shell defined so you have to define that. For example:

```sh
su -s /bin/bash  --command "./occ" www-data
```

References:
- https://docs.nextcloud.com/server/20/admin_manual/configuration_server/occ_command.html#occ-command-directory
- https://stackoverflow.com/a/71049540/51061


## TODO:
### Now:
- [x] Setup [mariadb via chart](https://github.com/nextcloud/helm/blob/main/charts/nextcloud/README.md#database-configurations)
  - [x] w/ secrets for user/db 
  - [x] w/ PV for mariadb
- [x] Setup chart w/ secrets for DB
- [x] Setup [persistence via chart](https://github.com/nextcloud/helm/blob/main/charts/nextcloud/README.md#persistence-configurations):
  - [x] setup PV
  - [x] persistence.enabled
- [x] Setup ingress manually - looks like the chart can do it, but is very nginx specific rather than k8s and k3s use traefik and just passes the values.yaml into an [empty ingress template](https://github.com/nextcloud/helm/blob/main/charts/nextcloud/templates/ingress.yaml) 🙄
  - [x] setup ingress paths per https://docs.nextcloud.com/server/latest/admin_manual/issues/general_troubleshooting.html#service-discovery-label (also the values.yaml of chart has a config for nginx)

### Later:
- [ ] Email mailrelay
