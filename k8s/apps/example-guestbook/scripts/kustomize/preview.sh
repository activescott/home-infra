#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
WORKSPACE_ROOT=`cd $THISDIR/../..; pwd` 
RESOURCE_ROOT="$WORKSPACE_ROOT"

set -x

# this essentially does a build and shows the combined set of resources that kustomize builds:

kubectl kustomize "$RESOURCE_ROOT"
