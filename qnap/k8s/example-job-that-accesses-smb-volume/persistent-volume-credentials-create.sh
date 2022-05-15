#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

die () {
    echo >&2 "$@"
    help
    exit 1
}

help () {
  echo 
  cat << END_DOC
USAGE: $THISSCRIPT [OPTIONS] COMMAND

END_DOC

}

source "$THISDIR/.env"

SMB_USERNAME=
SMB_PASSWORD=

read -p "Enter a username for the SMB share:" SMB_USERNAME
read -s -p "Enter a password for the SMB share:" SMB_PASSWORD

[ -z "$SMB_USERNAME" ] && die "username cannot be empty"
[ -z "$SMB_PASSWORD" ] && die "password cannot be empty"

echo "Deleting any existing smbcreds on cluster..."
kubectl delete secret smbcreds

echo "Creating smbcreds on cluster..."
kubectl create secret generic smbcreds --from-literal username="$SMB_USERNAME" --from-literal password="$SMB_PASSWORD"

kubectl get secret smbcreds 
echo "Creating smbcreds on cluster complete."
