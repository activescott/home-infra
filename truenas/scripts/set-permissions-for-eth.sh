#!/bin/bash

# Run this on the host
 
set -x

# compare this to the list of directories in the statefulset:
DIRECTORIES=(
  # erigon:
  "/mnt/ssdspace/eth-exec/nethermind/db"
  "/mnt/thedatapool/no-backup/app-data/nethermind"
  # lodestar:
  /mnt/thedatapool/no-backup/app-data/lodestar
  /mnt/ssdspace/eth-consensus/lodestar/chain-db
)

# this UID/GID are set creating a user on the host/node OS
# it also needs set in the kuberntes manifest under securityContext, runAsUser, fsGroup
USER=4010
GROUP=4010

for dir in "${DIRECTORIES[@]}"
do
  /usr/bin/sudo chown -v -R $USER:$GROUP "$dir"
  /usr/bin/sudo chmod -v -R u=rwX,g=rwX,o=rX "$dir"
done
