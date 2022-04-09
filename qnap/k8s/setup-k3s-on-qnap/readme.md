# setup-k3s-on-qnap

K3s is a fully conformant production-ready Kubernetes distribution that is very lightweight.
[K3s maintains an image on dockerhub](https://hub.docker.com/r/rancher/k3s) for running k3s as well as [providing instructions](https://rancher.com/docs/k3s/latest/en/advanced/#running-k3d-k3s-in-docker-and-docker-compose).

QNAP uses this image for their managed hosting of k8s in Container Station, but I had some trouble installing a CSI storage driver for smb/cifs on it and needed more control.

k3s docker container source is at https://github.com/k3s-io/k3s/blob/master/package/Dockerfile

## Usage

### Run K3s Container:

In container station's Preferences (on the left sidebar) Kubernetes is disabled (on the top right tab).

Use `10-generate-k3s-docker-compose.sh` in this folder to generate a new docker-compose file that that can be used in Container station. It populates `k3s-docker-compose.yml` with the needed environment variables `K3S_TOKEN` and `K3S_VERSION`.

Then run that outputted file in Container Station and k3s will run

### Connect kubectl:

Use `kubectl config set-cluster` to setup the cluster. For more info see https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration

To get the data you need open container station start a terminal from their weird ui and run `cat /etc/rancher/k3s/k3s.yaml` to see the full kubectl config. It has the certs and stuff you need in it already encoded. You can manually merge it into dev machine's `~/.kube/config` file and change the host to https://bitbox.activescott.com:6443

You can also run this from the below from the host/dev machine:

```sh
ssh scott@bitbox "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker exec myk3s_server_1 /bin/sh -c 'cat /etc/rancher/k3s/k3s.yaml'"
```

Or just run this via ssh:

Should be able to do something like `kubectl config set-cluster qnap --server=https://bitbox.activescott.com:6443 --certificate-authority=...` and then set context, etc., but I haven't gone through those details carefully enough to recite them.

To confirm it works run something like `kubectl get nodes`

### Setup Kubernetes Dashboard:

See 20-kubernetes-dashboard-deploy.sh

## TODO

- [+] Create docker-compose from template in k3s repo at https://github.com/k3s-io/k3s/blob/master/docker-compose.yml
- [+] Deploy image on qnap and get kubectl working from dev machine

- [ ] Install qnap kubernetes dashboard: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
  - [ ] expose via [LoadBalancer](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/) (for separate IP or port) via `kubectl expose...`:
    - [x]`kubectl expose service kubernetes-dashboard --port=61100 --target-port=443`
    - [+] `kubectl expose deployment kubernetes-dashboard --port=61100 --target-port=8443 --type=LoadBalancer --name=kubernetes-dashboard --namespace=kubernetes-dashboard`
    - [+] figure out how to get k3s `--service-node-port-range` set or change the docker-compose setup to forward the default ports to the node/host: see 20-kubernetes-dashboard-deploy.sh
