#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

source "$THISDIR/_include.base.sh"
source "$THISDIR/_include.args.sh"

# Use yq to extract the value of metadata.name directly from the YAML file
NAMESPACE=
if [ -f "$RESOURCE_ROOT/namespace.yaml" ]; then
  NAMESPACE=$(yq eval '.metadata.name' $RESOURCE_ROOT/namespace.yaml)
else
    echo "WARN: Skipping namespace deletion since no namespace file found at $RESOURCE_ROOT/namespace.yaml"
fi

# Get the app label from what was specified in the command line:
APP_LABEL=app.activescott.com/name=$K8S_APP_NAME

# Confirm with user
echo "Are you sure you want to delete all resources with label '$APP_LABEL'? This action cannot be undone. [y/N]"
read user_input

DRY_RUN=--dry-run=server
if [[ $user_input == "Y" ]] || [[ $user_input == "y" ]]; then
    RESOURCE_NAMES=$(kubectl api-resources -o name --verbs=delete | tr '\n' ',' | sed 's/,$//')
    echo "deleting resources with label '$APP_LABEL' ..."
    kubectl delete $DRY_RUN --all-namespaces --selector "$APP_LABEL" "$RESOURCE_NAMES"

    if [[ ! -z "$NAMESPACE" ]]; then
      echo "deleting namespace '$NAMESPACE'..."
      kubectl delete $DRY_RUN namespace $NAMESPACE
    fi
else
    echo "Operation cancelled"
fi
