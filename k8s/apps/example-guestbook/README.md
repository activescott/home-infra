# Example Guestbook App

This is my walkthrough of the [Kubernetes.io Example: Deploying PHP Guestbook application with Redis](https://kubernetes.io/docs/tutorials/stateless-application/guestbook/). Their source for the example is at https://github.com/kubernetes/website/tree/main/content/en/examples/application/guestbook

## Usage

This app is set up in the following two mutually exclusive ways two different ways herein:

1. Raw Kubernetes Resource files: The `./base/example/*.yaml` files contains the raw kubernetes files from the tutorial unchanged. You can deploy/use/clean them with the scripts in `./scripts/no-kustomize`.

2. Kustomize: The Kustomize approach patches the same resource files in `./base/example/*.yaml` and deploys them into two environments: guestbook-dev and guestbook-prod and deploys them slightly differently. You can deploy/use/clean them using scripts in `./scripts/kustomize`. See **Kustomize Notes** below for more.

### Kustomize Notes

Kustomize works by using the following three components:

1. `./base/kustomization.yaml`: This merely references the `./base/example/*.yaml` resources and applies a label to all of those resources.
2. `./overlays/dev/kustomization.yaml`: This one sets up the dev environment by referencing the base kustomization and (1) putting it in the guestbook-dev namespace and it changes teh frontend Deployment resource's replica count to 1 instead of 3. Note this service is only exposed internally to the cluster, so you have to use `kubectl portforward` to access it (see `./scripts/no-kustomize/port-forward.sh`)
3. `k8s/apps/example-guestbook/overlays/prod/kustomization.yaml`: This one also references the base, puts the resources in new namespace (guestbook-prod), but it also (1) changes the port and (2) exposes the frontend Service to the cluster loadbalancer so it can be accessed via https://<cluster-external-ip>:8888.
4. `./kustomization.yaml`: this one tells kustomize what to build by references the dev and prod kustomizations above. It also references a new resource file `guestbook-namespace.yaml` that creates the two namespaces for the environment so those don't have to be created in the example files itself.

## Kustomize References

The best overview of Kustomize is their readme: https://github.com/kubernetes-sigs/kustomize
Other references:

- https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/
- https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/
