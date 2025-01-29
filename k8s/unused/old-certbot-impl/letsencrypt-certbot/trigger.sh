#!/usr/bin/env bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
WORKSPACE_ROOT=`cd $THISDIR; pwd` 
RESOURCE_ROOT="$WORKSPACE_ROOT"

set -x

# have to deploy it first.
#kubectl delete job certbot
TSTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
echo $TSTAMP
kubectl create job "certbot-$TSTAMP" --from=cronjob/letsencrypt-certbot
