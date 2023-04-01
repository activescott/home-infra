#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
WORKSPACE_ROOT=`cd $THISDIR/../..; pwd` 

set -x

kubectl port-forward svc/frontend 8080:80
