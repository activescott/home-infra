#!/usr/bin/env bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
WORKSPACE_ROOT=`cd $THISDIR/../..; pwd` 
RESOURCE_ROOT="$WORKSPACE_ROOT"

set -x

kubectl delete namespace home-assistant
