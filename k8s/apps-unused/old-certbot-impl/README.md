# certbot via kubernetes

I have migrated away from this technique entirely using cert-manager instead which has worked wonderfully well.

For prosperity some notes on this old technique are below:

#### [k8s/apps/letsencrypt-certbot](k8s/apps/letsencrypt-certbot)

Before I started using cert-manager I ported over a solution I used for letencrypted from docker-compose. It is simply a kubernetes `CronJob` that runs certbot on a schedule and puts the cert in `/mnt/thedatapool/app-data/letsencrypt`

#### [k8s/apps/letsencrypt-secret-loader](k8s/apps/letsencrypt-secret-loader)

See [k8s/apps/letsencrypt-secret-loader/readme.md](k8s/apps/letsencrypt-secret-loader/README.md). DEPRECATED for cert-manager.

TLDR: You include the [k8s/apps/letsencrypt-secret-loader/kustomization.yaml](k8s/apps/letsencrypt-secret-loader/kustomization.yaml) file in your kustomization resources section so that it puts a secret in the app's kubernetes namespace that you can reference in the ingress. See
