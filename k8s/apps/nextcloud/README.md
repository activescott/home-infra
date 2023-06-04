# nextcloud in k8s

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
