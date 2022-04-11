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
USAGE: $THISSCRIPT [OPTIONS] COMMAND

END_DOC

}

source .env

kubectl apply -f "$THISDIR/shell-demo.yaml"

SECS=3
while [ $SECS -gt 0 ]; do
  printf "waiting $SECS seconds\n"
  sleep 1
  SECS=`expr $SECS - 1`
done

kubectl get pod shell-demo

kubectl exec --stdin --tty shell-demo -- /bin/sh
