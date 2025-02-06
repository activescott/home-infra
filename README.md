# home-infra

The intent here is to maintain various apps and configurations that I run at home. Below is more detail about each.

## Usage

Each subdirectory of `k8s/apps` (well most of them) represents an app or some infrastructure component in support of the apps. The name of the subdirectory segment is the `app-name` below. Each script/command is as follows:

- `./k8s/scripts/deploy.sh <app-name>`: Deploy the app. For example `./k8s/scripts/deploy.sh plex` will deploy the plex app to the cluster.
- `./k8s/scripts/preview.sh <app-name>`: Spits out the final kubernetes yaml after it is resolved from kustomize. It will also reveal any client-detectable errors in the yaml. Does not deploy anything to the cluster.
- `./k8s/scripts/clean.sh <app-name>`: Delete the app from the cluster. It _immediately_ **deletes** the app. So be careful!

## k8s/apps

Most of these are now in the process of being moved to https://github.com/activescott/home-infra-k8s-flux
They are largely unchanged only minor modifications to support flux (e.g. secrets management).

These are my apps running at home in Kubernetes. I am currently using k3s on either debian or TrueNAS (playing with both).

### [k8s/apps/home-assistant](k8s/apps/home-assistant)

This is my [Home Assistant](https://www.home-assistant.io) + [ZWave JS zwavejs2mqtt Server](https://github.com/zwave-js/zwavejs2mqtt) implementation running on docker. See [k8s/apps/home-assistant/README.md](k8s/apps/home-assistant/README.md)

### [k8s/apps/plex](k8s/apps/plex)

A [Plex Media Server](https://www.plex.tv/media-server-downloads/#plex-media-server) on kubernetes.

### [k8s/apps/photoprism](k8s/apps/photoprism)

Photoprism is setup for photos.scott.willeke.com and photos.oksana.willeke.com

### [k8s/apps/transmission](k8s/apps/transmission)

A [Transmission Bittorrent server](https://transmissionbt.com/) to download and seed torrents.

### [k8s/apps/unifi](k8s/apps/unifi)

A Ubiquity/Unifi Controller app setup running.

### Infrastructure/Supporting Apps

The apps below here are installed to support the other apps in the cluster.

#### [k8s/apps/cert-manager](k8s/apps/cert-manager)

This is a cert manager instance that provisions certificates for _.scott.willeke.com, _.oksana.willeke.com, and \*.activescott.com.

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

## Notes to Self

### Kubernetes Memory & Limits

Specify a memory limit on containers (`spec.containers[].resources.limits.memory`). The limit appears to correspond to Prometheus metric `container_memory_usage_bytes`. The `container_memory_usage_bytes` metric though includes cached (think filesystem cache) items that can be evicted under memory pressure ([ref1](https://stackoverflow.com/a/66778814/51061), [ref2](https://faun.pub/how-much-is-too-much-the-linux-oomkiller-and-used-memory-d32186f29c9d) [ref3](https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/#exceed-a-container-s-memory-limit)).

The `container_memory_working_set_bytes` is what the OOMKiller watches though and that tends to be much lower. The `limit` specified in YAML is honored in two ways (this insight from [ref2](https://faun.pub/how-much-is-too-much-the-linux-oomkiller-and-used-memory-d32186f29c9d)):

1. If the pod's `container_memory_usage_bytes` gets hits the limit then then the pod/container (OS?) will reduce the cache memory to keep the pod under the limit as long as `container_memory_working_set_bytes` + `container_memory_cache` < limit.
2. If the `container_memory_working_set_bytes` isn't brought under the limit, then OOMKiller will kill the pod/container.

#### Do Requests need to be specified?

> Note: If you specify a limit for a resource, but do not specify any request, and no admission-time mechanism has applied a default request for that resource, then Kubernetes copies the limit you specified and uses it as the requested value for the resource. – https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Yes.

#### Pods without Limits Specified

To identify pods without memory resource limit specified:

```sh
$ kubectl get pods --all-namespaces -o json | jq -r '.items[] | select(.spec.containers[].resources.limits.memory == null) | .metadata.name'
```

---

## TODO:

### port this to a flux repo:

note: flex will not garabage collect resources that it did not create: https://github.com/fluxcd/flux2/discussions/2901
steps:

#### Install Flux CLI

per https://fluxcd.io/flux/installation/#install-the-flux-cli

```sh
brew install fluxcd/tap/flux
. <(flux completion zsh)
```

#### Move all secrets to SOPS and age: https://fluxcd.io/flux/guides/mozilla-sops/#encrypting-secrets-using-age. Something like this:

- [ ] generate key (aka "recipient"): `age-keygen -o home-infra-private.agekey`
      NOTE: Create a secret with the age private key, the key name must end with .agekey to be detected as an age key:

> You can specify the location of this file manually by setting the environment variable SOPS_AGE_KEY_FILE. Alternatively, you can provide the key(s) directly by setting the SOPS_AGE_KEY environment variable. - https://github.com/getsops/sops?tab=readme-ov-file#encrypting-using-age

so something like:

SOPS_AGE_KEY_FILE=<keyfile location>

```sh
SOPS_AGE_KEY_FILE=/Users/scott/src/activescott/home-infra/k8s/home-infra-private.agekey sops encrypt --age age1nur86m07v4f94xpc8ugg0cmum9fpyp3hcha2cya6x09uphu4zg5szrtzgt --input-type dotenv --output-type dotenv .env.secret.transmission > .env.enc.transmission
```

Then commit them to the repo in the right place.

    - [ ] follow new-repo creation guide at https://fluxcd.io/flux/get-started/. It will essentially bootstrap a repo and it will be empty

To enable flux to decrypt them do (per https://fluxcd.io/flux/guides/mozilla-sops/#encrypting-secrets-using-age):

```
cat age.agekey |
kubectl create secret generic sops-age \
--namespace=flux-system \
--from-file=age.agekey=/dev/stdin
```

> And finally set the decryption secret in the Flux Kustomization to sops-age.
>
> - https://fluxcd.io/flux/guides/mozilla-sops/#encrypting-secrets-using-age
>   Huh?

#### Install flux & Bootstrap

Install: https://fluxcd.io/flux/installation/

Bootstrap Repo/Cluster: https://fluxcd.io/flux/installation/bootstrap/github/

#### Migrate Workloads

Start migrating workloads to flux repo from the old home-infra repo

---

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
- [x] add metricserver to scrap metrics via prometheus
- [ ] add email mailrelay host - port it from docker
- [ ] Remote syslog server routed into kibana or similar.
- [ ] Alerting needs setup if a cron job fails. Kibana container with alerting? stdin+logstash?
