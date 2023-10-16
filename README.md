# home-infra

The intent here is to maintain various apps and configurations that I run at home. Below is more detail about each.

## Usage

Each subdirectory of `k8s/apps` (well most of them) represents an app or some infrastructure component in support of the apps. The name of the subdirectory segment is the `app-name` below. Each script/command is as follows:

- `./k8s/scripts/deploy.sh <app-name>`: Deploy the app. For example `./k8s/scripts/deploy.sh plex` will deploy the plex app to the cluster.
- `./k8s/scripts/preview.sh <app-name>`: Spits out the final kubernetes yaml after it is resolved from kustomize. It will also reveal any client-detectable errors in the yaml. Does not deploy anything to the cluster.
- `./k8s/scripts/clean.sh <app-name>`: Delete the app from the cluster. It _immediately_ **deletes** the app. So be careful!

## k8s/apps

These are my apps running at home in Kubernetes. I am currently using k3s on either debian or TrueNAS (playing with both).

### [k8s/apps/home-assistant](k8s/apps/home-assistant)

This is my [Home Assistant](https://www.home-assistant.io) + [ZWave JS zwavejs2mqtt Server](https://github.com/zwave-js/zwavejs2mqtt) implementation running on docker. See [containers/home-assistant/README.md](containers/home-assistant/README.md)

### [k8s/apps/plex](k8s/apps/plex)

A [Plex Media Server](https://www.plex.tv/media-server-downloads/#plex-media-server) on kubernetes.

### [k8s/apps/photoprism](k8s/apps/photoprism)

Photoprism is setup for photos.scott.willeke.com and photos.oksana.willeke.com

### [k8s/apps/unifi](k8s/apps/unifi)

A Ubiquity/Unifi Controller app setup running.

### Infrastructure/Supporting Apps

The apps below here are installed to support the other apps in the cluster.

#### [k8s/apps/cert-manager](k8s/apps/cert-manager)

This is a cert manager instance that provisions certificates for _.scott.willeke.com, _.oksana.willeke.com, and \*.activescott.com.

#### [k8s/apps/letsencrypt-certbot](k8s/apps/letsencrypt-certbot)

Before I started using cert-manager I ported over a solution I used for letencrypted from docker-compose. It is simply a kubernetes `CronJob` that runs certbot on a schedule and puts the cert in `/mnt/thedatapool/app-data/letsencrypt`

#### [k8s/apps/letsencrypt-secret-loader](k8s/apps/letsencrypt-secret-loader)

See [k8s/apps/letsencrypt-secret-loader/readme.md](k8s/apps/letsencrypt-secret-loader/README.md).

TLDR: You include the [k8s/apps/letsencrypt-secret-loader/kustomization.yaml](k8s/apps/letsencrypt-secret-loader/kustomization.yaml) file in your kustomization resources section so that it puts a secret in the app's kubernetes namespace that you can reference in the ingress. See

#### k8s/apps/k8tz

Sucks to see different times in logs of apps, k8tz is provisioned to ensure that all the pods/containers are provisioned with the same timezone as the host.

## How it Works

### Kustomize

I use Kustomize for packaging my kubernetes apps. Where with helm you create a pre-packaged component with pre-defined set of extensibility points that can be customized (i.e. in values.yaml), Kustomize references an existing Kubernetes "app" (think of these as an "example app") and Kustomize is then used to customize the the app for your needs with _patches_ to add, remove, or change values in the kubernetes resources. It can customize anything in the referenced app's Kubernetes resources. By convention, the "example app" is usually defined in a `base` folder as a standard set of kubernetes resources and each patched version is usually a subfolder of the `overlays` folder.
I'd say Helm provides better encapsulation if you have say a lot of dependents, but kustomize has less formality and learning and is a bit closer to simple/plain kubernetes.

The best overview of Kustomize is their readme: https://github.com/kubernetes-sigs/kustomize

A good example of using overlays is https://github.com/kubernetes-sigs/kustomize/blob/master/examples/springboot/

Reference for Kustomization files: https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/

Good detail on different patches at https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patches/

### K8s Labels:

I put a couple labels on various Kubernetes resources to help ensure they're organized and understandable.

TLDR:

```yaml
commonLabels:
  # use `app.activescott.com/name` to avoid conflicts with other people's resources using "app" label.
  app.activescott.com/name: app-name
  app.activescott.com/tenant: everyone # or scott or oksana, etc.
```

---

## TODO:

- [x] Setup photos.scott.willeke.com certs and ingress:

  - [x] Dynamic DNS Update the DNS records using OPNSense:

    - Help: https://support.google.com/domains/answer/6147083?hl=en
    - TLDR: Go to https://domains.google.com/registrar/willeke.com/dns and got o advanced and expand and Dynamic DNS...

  - [x] Install and configure cert-manager & configure with ACME on gDomains:

    - DNS01 challenges Requires a non-standard issuer according to https://github.com/cert-manager/cert-manager/issues/5877#issuecomment-1483260982 . Someone created a webhook integration at https://github.com/dmahmalat/cert-manager-webhook-google-domains to make it work. More from google on ACME at https://support.google.com/domains/answer/7630973?authuser=0&hl=en#acme_dns. HTTP01 looks easier!
    - Using HTTP01 should be easier: https://cert-manager.io/docs/tutorials/acme/http-validation/ & https://cert-manager.io/docs/configuration/acme/http01/
      - Set up ClusterIssuer for photos.scott.willeke.com (ClusterIssuer since it is non-namespaced).

  - [x] ~~Replicate secrets with kubernetes-replicator and "pull-based replication" Configure pull-based replication: https://github.com/mittwald/kubernetes-replicator#pull-based-replication & https://cert-manager.io/docs/tutorials/syncing-secrets-across-namespaces/#using-kubernetes-replicator~~ – Just create the `Certificate` resources in whatever namespace needs it.

  - [x] Create a `Certificate` resource for `letsencrypt-production` `ClusterIssuer` in the PhotoPrism namespace for photos.scott.willeke.com (in the overlay). Make sure it works! Then document it in a cert-manager README.md.

  - [x] Create an overlay for photos.oksana.willeke.com w/ cert

- [x] try [nextcloud's helm chart](https://github.com/nextcloud/helm/tree/main/charts/nextcloud) via kustomize
- [ ] Flux:
  - See https://fluxcd.io/flux/get-started/
  - See https://github.com/fluxcd/flux2-kustomize-helm-example
- [ ] switch remaining `hostPath` k8s volumes to PVs with `local` provisioner instead [1](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/persistent-volume-v1/#local) [2](https://kubernetes.io/docs/concepts/storage/volumes/#local)
- [ ] add metricserver to scrap metrics via prometheus
- [ ] add email mailrelay host - port it from docker
- [ ] Remote syslog server routed into kibana or similar.
- [ ] Alerting needs setup if a cron job fails. Kibana container with alerting? stdin+logstash?
