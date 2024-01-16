#!/usr/bin/env bash

# Run this on the host
 
#set -x

# compare this to the list of directories in the statefulset:
DIRECTORIES=(
  "/mnt/thedatapool/no-backup/app-data/prometheus"
)

# this UID/GID are set creating a user on the host/node OS
# it also needs set in the kuberntes manifest under securityContext, runAsUser, fsGroup
USER=4030
GROUP=4030

for dir in "${DIRECTORIES[@]}"
do
  mkdir -pv "$dir"
  /usr/bin/sudo chown -v -R $USER:$GROUP "$dir"
  /usr/bin/sudo chmod -v -R u=rwX,g=rwX,o=rX "$dir"
done
