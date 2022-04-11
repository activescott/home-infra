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

source "$THISDIR/.env"


VOLUME_NAME=vol-app-data

kubectl delete -n default persistentvolumeclaim pvc-$VOLUME_NAME
kubectl delete -n default persistentvolume $VOLUME_NAME
