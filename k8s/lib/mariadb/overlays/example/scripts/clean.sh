#!/usr/bin/env bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)
WORKSPACE_ROOT=`cd $THISDIR/../..; pwd` 
RESOURCE_ROOT=`cd $THISDIR/..; pwd` 

# Use yq to extract the value of metadata.name directly from the YAML file
NAMESPACE=
NAMESPACE=$(yq eval '.metadata.name' $RESOURCE_ROOT/namespace.yaml)

if [ -z $NAMESPACE ]; then
  echo "no namespace!"
  exit 1
fi 

# Print the value
echo "cleaning namespace '$NAMESPACE'..."

set -x

kubectl delete namespace $NAMESPACE
