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
USAGE: $THISSCRIPT [OPTIONS]


END_DOC

}

source .env

echo; echo "preparing the server container:"

echo; echo "Enter the name of the app in containerstation (e.g. myk3s):"
read MY_K3S_APP_NAME


while true; do
    read -p "Using app name $MY_K3S_APP_NAME (so ${MY_K3S_APP_NAME}_server_1 and ${MY_K3S_APP_NAME}_agent_1). Do you wish to continue? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


SSH_HOST=scott@bitbox
echo "setting up SSH ControlMaster for $SSH_HOST"
# setup an SSH ControlMaster socket that other SSH connections can use:
CONTROL_PATH=~/.ssh/%r@%h-%p

# -f: background
# -M: ControlMastern

# -S: The socket path that other ssh instances will also use to connect via this ControlMaster.
ssh -f -M  -S $CONTROL_PATH -o ControlMaster=yes -o ControlPersist=120 $SSH_HOST /bin/bash

# Check the SSH ControlMaster is running:
ssh -S $CONTROL_PATH -o ControlMaster=no $SSH_HOST -O 'check'

echo; echo "Peparing ${MY_K3S_APP_NAME}_server_1..."
ssh -S "$CONTROL_PATH" "$SSH_HOST" "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker exec ${MY_K3S_APP_NAME}_server_1 /bin/sh -c 'mount -o bind /var/lib/kubelet /var/lib/kubelet'"
[ $? ] || die "command failed!"
ssh -S "$CONTROL_PATH" "$SSH_HOST" "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker exec ${MY_K3S_APP_NAME}_server_1 /bin/sh -c 'mount --make-shared /var/lib/kubelet'"
[ $? ] || die "command failed!"
ssh -S "$CONTROL_PATH" "$SSH_HOST" "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker exec ${MY_K3S_APP_NAME}_server_1 /bin/sh -c 'mount --make-shared /'"
[ $? ] || die "command failed!"


echo; echo "Peparing ${MY_K3S_APP_NAME}_agent_1..."
ssh -S "$CONTROL_PATH" "$SSH_HOST" "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker exec ${MY_K3S_APP_NAME}_agent_1 /bin/sh -c 'mount -o bind /var/lib/kubelet /var/lib/kubelet'"
[ $? ] || die "command failed!"
ssh -S "$CONTROL_PATH" "$SSH_HOST" "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker exec ${MY_K3S_APP_NAME}_agent_1 /bin/sh -c 'mount --make-shared /var/lib/kubelet'"
[ $? ] || die "command failed!"
ssh -S "$CONTROL_PATH" "$SSH_HOST" "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker exec ${MY_K3S_APP_NAME}_agent_1 /bin/sh -c 'mount --make-shared /'"
[ $? ] || die "command failed!"
