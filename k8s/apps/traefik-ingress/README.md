# traefik ingress

K3S bundles Traefik for it's ingress controller as explained [here](https://docs.k3s.io/networking#traefik-ingress-controller) and implemented [here](https://github.com/k3s-io/k3s/blob/v1.25.3%2Bk3s1/manifests/traefik.yaml). However, on TrueNAS when they install k3s they disable/remove the traefik ingress controller. so `Ingress` resources have no effect. This adds Traefik back as the default ingress controller .

## Helm

Note that the Traefik helm chart is the preferred way to install Traefik according to [Traefik docs](https://doc.traefik.io/traefik/getting-started/install-traefik/).

NOTE: You can install Traefik without Helm as demonstrated at https://blog.tomarrell.com/post/traefik_v2_on_kubernetes.
We can also use the Helm chart via Kustomize as described at https://kubectl.docs.kubernetes.io/references/kustomize/builtins/#_helmchartinflationgenerator_

## `Ingress` vs `IngressRoute` Resources

Traefik tends to prefer their [non-standard `IngressRoute` Kubernetes Custom Resource Definition](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/). However, Traefik will handle [standard `Ingress` resources via its Ingress Controller](https://doc.traefik.io/traefik/routing/providers/kubernetes-ingress/) if you configure Traefik to do so. More specific details on configuring `Ingress` resources handled by the Traefik Ingress Controller is at https://doc.traefik.io/traefik/providers/kubernetes-ingress/
