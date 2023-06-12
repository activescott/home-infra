# home-infra

The intent here is to maintain various apps and configurations that I run at home. Below is more detail about each.

## k8s/apps

These are my apps running at home in Kubernetes. I am currently using k3s on either debian or TrueNAS (playing with both).

### Kustomize

I use Kustomize for packaging my kubernetes apps. Where with helm you create a pre-packaged component with pre-defined set of extensibility points that can be customized (i.e. in values.yaml), Kustomize references an existing Kubernetes "app" (think of these as an "example app") and Kustomize is then used to customize the the app for your needs with _patches_ to add, remove, or change values in the kubernetes resources. It can customize anything in the referenced app's Kubernetes resources. By convention, the "example app" is usually defined in a `base` folder as a standard set of kubernetes resources and each patched version is usually a subfolder of the `overlays` folder.
I'd say Helm provides better encapsulation if you have say a lot of dependents, but kustomize has less formality and learning and is a bit closer to simple/plain kubernetes.

The best overview of Kustomize is their readme: https://github.com/kubernetes-sigs/kustomize

A good example of using overlays is https://github.com/kubernetes-sigs/kustomize/blob/master/examples/springboot/

Reference for Kustomization files: https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/

Good detail on different patches at https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patches/

## k8s/apps/home-assistant

This is my [Home Assistant](https://www.home-assistant.io) + [ZWave JS zwavejs2mqtt Server](https://github.com/zwave-js/zwavejs2mqtt) implementation running on docker. See [containers/home-assistant/README.md](containers/home-assistant/README.md)

# containers/unifi-controller (TODO: Move to k8s)

A Ubiquity/Unifi Controller app setup running on docker. See [containers/unifi-controller/README.md](containers/unifi-controller/README.md)

# TODO:

- [ ] Setup photos.scott.willeke.com certs and ingress:

  - [x] Dynamic DNS Update the DNS records using OPNSense:

    - Help: https://support.google.com/domains/answer/6147083?hl=en
    - TLDR: Go to https://domains.google.com/registrar/willeke.com/dns and got o advanced and expand and Dynamic DNS...

  - [ ] Install and configure cert-manager & configure with ACME on gDomains:

    - DNS01 challenges Requires a non-standard issuer according to https://github.com/cert-manager/cert-manager/issues/5877#issuecomment-1483260982 . Someone created a webhook integration at https://github.com/dmahmalat/cert-manager-webhook-google-domains to make it work. More from google on ACME at https://support.google.com/domains/answer/7630973?authuser=0&hl=en#acme_dns. HTTP01 looks easier!
    - Using HTTP01 should be easier: https://cert-manager.io/docs/tutorials/acme/http-validation/ & https://cert-manager.io/docs/configuration/acme/http01/
      - Set up ClusterIssuer for photos.scott.willeke.com (ClusterIssuer since it is non-namespaced).

  - [ ] Replicate secrets with kubernetes-replicator and "pull-based replication":
    - Install https://github.com/mittwald/kubernetes-replicator#manual
    - Configure pull-based replication: https://github.com/mittwald/kubernetes-replicator#pull-based-replication & https://cert-manager.io/docs/tutorials/syncing-secrets-across-namespaces/#using-kubernetes-replicator

- [ ] fix scripts/clean.sh so that it knows how to deal with each overlay having its own namespace.
- [ ] try [nextcloud's helm chart](https://github.com/nextcloud/helm/tree/main/charts/nextcloud) via kustomize
- [ ] Flux!
- [ ] switch remaining `hostPath` k8s volumes to PVs with `local` provisioner instead [1](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/persistent-volume-v1/#local) [2](https://kubernetes.io/docs/concepts/storage/volumes/#local)
- [ ] add metricserver to scrap metrics via prometheus
- [ ] add email mailrelay host - port it from docker
- [ ] Remote syslog server routed into kibana or similar.
- [ ] Alerting needs setup if a cron job fails. Kibana container with alerting? stdin+logstash?
