# setup-k3s-on-qnap

K3s is a fully conformant production-ready Kubernetes distribution that is very lightweight.
[K3s maintains an image on dockerhub](https://hub.docker.com/r/rancher/k3s) for running k3s as well as [providing instructions](https://rancher.com/docs/k3s/latest/en/advanced/#running-k3d-k3s-in-docker-and-docker-compose).

QNAP uses this image for their managed hosting of k8s in Container Station, but I had some trouble installing a CSI storage driver for smb/cifs on it and needed more control.

k3s docker container source is at https://github.com/k3s-io/k3s/blob/master/package/Dockerfile

## Usage

### TLDR;

```sh
./cluster-local-create.sh
./cluster-smb-driver-install.sh

# Optional for monitoring:
./dashboard-deploy.sh

# optional to test the smb/cifs driver works:
cd ../example-job-that-accesses-smb-volume/
./persistent-volume-credentials-create.sh
./persistent-volume-create.sh
./job-create.sh

```

### Issues

#### DNS Resolution of Local LAN Doesn't Work

CoreDNS is the cluster DNS. Pods query it for service discovery (other pods/services in K8s) and other DNS resolution. It is using the K8S Node's `resolve.conf` file to forward unknown (external DNS) requests to. When running a node in Docker it uses something like `127.0.0.11` which works for finding other docker hosts, but not external hosts using the local LAN's DNS. This issue is explained at https://github.com/k3s-io/k3s/issues/1863#issuecomment-643154410

The way I chose to solve it is by patching the cluster-wide CoreDNS configuration as noted at https://devops.stackexchange.com/a/6521/30875. This is codified in `cluster-dns-config-for-local-forward.sh`

A better way to fix this is informed by the note that _Any file found in /var/lib/rancher/k3s/server/manifests_ in [the K3S FAQ](https://rancher.com/docs/k3s/latest/en/advanced/#auto-deploying-manifests). Basically an extra CoreDNS config like `coredns-patch.yaml` into `/var/lib/rancher/k3s/server/manifests/` and it will be applied upon each restart automatically by k3s.

One way to potentially fix this is to tell k3s to use a different `resolve.conf` using the `K3S_RESOLVE_CONF` configuration parameter. This will survive reboots and updates of K3S as described at https://github.com/k3s-io/k3s/issues/1863#issuecomment-643154410

##### References:

- https://github.com/k3s-io/k3s/issues/1863
- https://stackoverflow.com/questions/62664701/resolving-external-domains-from-within-pods-does-not-work
- https://stackoverflow.com/a/71245831/51061
- https://github.com/k3s-io/k3s/issues/4087 Using K3S --resolv-conf

### Run K3s Container:

In container station's Preferences (on the left sidebar) Kubernetes is disabled (on the top right tab).

Use `k3s-docker-compose-generate.sh` in this folder to generate a new docker-compose file that that can be used in Container station. It creates a new file based on `k3s-docker-compose.yml` populated with the needed environment variables `K3S_TOKEN` and `K3S_VERSION` into a file similar to `k3s-docker-compose-resolved-at-2022041019251600000000.yaml`.

Then run that outputted file in Container Station/docker compose and it should get a k3s cluster working with an agent and server instance.

OR run `cluster-local-create.sh` to spin it up in docker-compose locally.

### Connect kubectl:

NOTE: `cluster-local-create.sh` creates a `k3s-kubectl-config.yaml` in the current directory and you can use kctl.sh to run kubectl commands.

Use `kubectl config set-cluster` to setup the cluster. For more info see https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration

To get the data you need open container station start a terminal from their weird ui and run `cat /etc/rancher/k3s/k3s.yaml` to see the full kubectl config. It has the certs and stuff you need in it already encoded. You can manually merge it into dev machine's `~/.kube/config` file and change the host to https://bitbox.activescott.com:6443

You can also run this from the below from the host qnap machine to print out the details from the k3s container:

```sh
ssh scott@bitbox "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker exec myk3s_server_1 /bin/sh -c 'cat /etc/rancher/k3s/k3s.yaml'"
```

You should be able to run this to set configure `kubectl`:

Should be able to do something like `kubectl config set-cluster qnap --server=https://bitbox.activescott.com:6443 --certificate-authority=...` and then set context, etc., but I haven't gone through those details carefully enough to recite them.

To confirm it works run something like `kubectl get nodes`

### Setup Kubernetes Dashboard:

See `dashboard-deploy.sh`

###

## TODO

- [+] Create docker-compose from template in k3s repo at https://github.com/k3s-io/k3s/blob/master/docker-compose.yml
- [+] Deploy image on qnap and get kubectl working from dev machine

- [x] Install qnap kubernetes dashboard: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
  - [ ] expose via [LoadBalancer](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/) (for separate IP or port) via `kubectl expose...`:
    - [x]`kubectl expose service kubernetes-dashboard --port=61100 --target-port=443`
    - [+] `kubectl expose deployment kubernetes-dashboard --port=61100 --target-port=8443 --type=LoadBalancer --name=kubernetes-dashboard --namespace=kubernetes-dashboard`
    - [+] figure out how to get k3s `--service-node-port-range` set or change the docker-compose setup to forward the default ports to the node/host: see 20-kubernetes-dashboard-deploy.sh
