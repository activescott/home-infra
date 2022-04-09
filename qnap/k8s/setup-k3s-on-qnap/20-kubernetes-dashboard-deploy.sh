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

# This line is the standard way to deploy the dashboard:https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#accessing-the-dashboard-ui
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml

# Now expose the deployment via new service configured via loadbalancer, this is an one-liner way to create the service resource:

echo; echo "Creating loadbalancer..."
kubectl expose deployment kubernetes-dashboard --port=61100 --target-port=8443 --type=LoadBalancer --name=kubernetes-dashboard-lb --namespace=kubernetes-dashboard

kubectl describe service kubernetes-dashboard-lb --namespace=kubernetes-dashboard

echo; echo "Creating dashboard admin-user..."
# from https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

kubectl apply -f dashboard-service-account.yaml

# TODO: THIS NEEDS TO WAIT until the pods come up

./22-kubernetes-dashboard-print-secret.sh
