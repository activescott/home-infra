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

JOB_NAME=example-ls-job

PODS=$(kubectl get pods --selector=job-name=$JOB_NAME --output=jsonpath='{.items[*].metadata.name}')
echo "Found pods for job '$JOB_NAME': $PODS"
echo 
kubectl logs $PODS

