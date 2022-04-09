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

# uninstall the SMB CSI Driver for Kubernetes via helm: https://github.com/kubernetes-csi/csi-driver-smb
helm uninstall csi-driver-smb --namespace kube-system
