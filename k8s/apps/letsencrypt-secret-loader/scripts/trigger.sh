#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
WORKSPACE_ROOT=`cd $THISDIR; pwd` 
RESOURCE_ROOT="$WORKSPACE_ROOT"

set -x

# have to deploy it first.

TSTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
echo $TSTAMP
kubectl create job "letsencrypt-secret-loader-$TSTAMP" --namespace=letsencrypt-secret-loader --from=cronjob/letsencrypt-secret-loader
