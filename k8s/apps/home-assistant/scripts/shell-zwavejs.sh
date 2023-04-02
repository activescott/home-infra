#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
WORKSPACE_ROOT=`cd $THISDIR/../..; pwd` 
RESOURCE_ROOT="$WORKSPACE_ROOT"

set -x

kubectl -n=home-assistant exec -it deployment/zwavejs -- /bin/sh
