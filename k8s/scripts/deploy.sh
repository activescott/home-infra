#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

source "$THISDIR/_include.base.sh"
source "$THISDIR/_include.args.sh"

set -x

kubectl kustomize --enable-helm "$RESOURCE_ROOT" | kubectl apply -f -
