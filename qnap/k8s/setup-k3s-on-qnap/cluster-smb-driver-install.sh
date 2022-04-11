#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

die () {
    echo >&2 "$@"
    help
    exit 1
}

help () {
  echo 
  cat << END_DOC
USAGE: $THISSCRIPT [OPTIONS]


END_DOC

}

source .env

# Following the instructions from https://github.com/kubernetes-csi/csi-driver-smb/issues/191#issuecomment-754430561 which directs you to https://github.com/kubernetes-retired/kubernetes-anywhere/issues/88#issuecomment-292407728 enter these commands **on the agent and the server docker-compose conainers** (via terminal in container station as a handjamb, need to automate somehow):
# mount -o bind /var/lib/kubelet /var/lib/kubelet
# mount --make-shared /var/lib/kubelet

# or via while ssh into bitbox:
# docker exec -it myk3s_server_1 /bin/sh -c "mount -o bind /var/lib/kubelet /var/lib/kubelet ; mount --make-shared /var/lib/kubelet"
# docker exec -it myk3s_agent_1 /bin/sh -c "mount -o bind /var/lib/kubelet /var/lib/kubelet ; mount --make-shared /var/lib/kubelet"

# install the SMB CSI Driver for Kubernetes via helm: https://github.com/kubernetes-csi/csi-driver-smb
DRIVER_VERSION=v1.5.0

K3S_CONFIG_FILE=./k3s-kubectl-config.yaml

echo "adding repo..."
helm --kubeconfig $K3S_CONFIG_FILE repo add csi-driver-smb https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/charts

echo "installing csi-driver-smb driver..."
helm --kubeconfig $K3S_CONFIG_FILE install csi-driver-smb csi-driver-smb/csi-driver-smb --namespace kube-system --version $DRIVER_VERSION

echo "installing csi-driver-smb driver complete."
echo "Monitoring relevant pods. Press Ctrl+C to stop:"
kubectl --kubeconfig=$K3S_CONFIG_FILE --namespace=kube-system get pods --selector="app in (csi-smb-controller, csi-smb-node)" --watch

echo 'Run   kubectl -n=kube-system -o=yaml get pod <pod name>   to get more detail on a particualr pod'
