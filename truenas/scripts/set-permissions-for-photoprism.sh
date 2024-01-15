#!/bin/bash

set -x

DIRECTORIES=(
  #"/mnt/thedatapool/app-data/photoprism-scott"
  "/mnt/thedatapool/app-data/photoprism-oksana"
)

USER=photoprism
GROUP=photoprism

for PATH in "${DIRECTORIES[@]}"
do
  /usr/bin/sudo chown -R $USER:$GROUP "$PATH"
  /usr/bin/sudo chmod -R u=rwX,g=rwX,o=rX "$PATH"
done

