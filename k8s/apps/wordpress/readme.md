Installs wordpress and mysql database from https://github.com/bitnami/charts/tree/main/bitnami/wordpress

Can work with the bitnami helm chart repo on the cli like this:

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
```

To see just wordpress charts (and current version):

```
helm search repo bitnami/wordpress
```

## TODO:

- [ ] Set it up as a base and multiple overlays. I set this up to get it working quickly without giving much thought to what is in an overlay and what is in the base, because I wasn't sure if we'd use this long term. If we do keep using it, makes sense to put this into a base and overlay accordingly.
