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

Installs the kubernetes dashboard https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
END_DOC

}

kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml

# delete dashboard admin-user:
kubectl delete -f dashboard-service-account.yaml

# delete loadbalancer used to expose it:
kubectl delete service kubernetes-dashboard-lb -n kubernetes-dashboard
