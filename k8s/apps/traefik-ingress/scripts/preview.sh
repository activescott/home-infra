#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

RESOURCE_ROOT=`cd $THISDIR/..; pwd` 

set -x

kubectl kustomize --enable-helm "$RESOURCE_ROOT"
