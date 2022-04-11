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

source "$THISDIR/.env"

echo; echo "Printing dashboard admin-user token:"
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
echo

echo; echo "Now visit https://bitbox.activescott.com:61100 and enter the token from above"
