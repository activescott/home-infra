#!/bin/bash

set -x

DIRECTORIES=(
  #"/mnt/thedatapool/app-data/photoprism-scott"
  "/mnt/thedatapool/app-data/photoprism-oksana"
)

USER=photoprism
GROUP=photoprism

for dir in "${DIRECTORIES[@]}"
do
  /usr/bin/sudo chown -R $USER:$GROUP "$dir"
  /usr/bin/sudo chmod -R u=rwX,g=rwX,o=rX "$dir"
done

