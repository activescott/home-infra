#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
WORKSPACE_ROOT=`cd $THISDIR/..; pwd` 
RESOURCE_ROOT="$WORKSPACE_ROOT"

set -x

kubectl apply -f "$RESOURCE_ROOT/home-assistant-namespace.yaml"
kubectl apply -f "$RESOURCE_ROOT/base/zwavejs-deployment.yaml"
