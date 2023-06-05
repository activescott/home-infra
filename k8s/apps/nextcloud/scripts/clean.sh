#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

RESOURCE_ROOT=`cd $THISDIR/..; pwd` 

# Use yq to extract the value of metadata.name directly from the YAML file
NAMESPACE=
NAMESPACE=$(yq eval '.metadata.name' $RESOURCE_ROOT/namespace.yaml)

APP_LABEL=app=nextcloud-prod

if [ -z $NAMESPACE ]; then
  echo "no namespace!"
  exit 1
fi 

echo "cleaning namespace '$NAMESPACE'..."

kubectl delete namespace $NAMESPACE

echo "Are you sure you want to delete all resources with label '$APP_LABEL'? This action cannot be undone. [y/N]"

read user_input

if [[ $user_input == "Y" ]] || [[ $user_input == "y" ]]; then
    RESOURCE_NAMES=$(kubectl api-resources -o name | tr '\n' ',' | sed 's/,$//')
    kubectl delete --all-namespaces -l "$APP_LABEL" "$RESOURCE_NAMES"
else
    echo "Operation cancelled"
fi
