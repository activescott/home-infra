#!/usr/bin/env bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

source "$THISDIR/_set-image-and-tag.sh"

echo "Removing any existing container $IMAGE_NAME..."
docker container rm $IMAGE_NAME

echo "Running activescott/$IMAGE_NAME:$TAGNAME..."
#docker run --name $IMAGE_NAME -it activescott/$IMAGE_NAME:$TAGNAME
#docker run --name $IMAGE_NAME --detach activescott/$IMAGE_NAME:$TAGNAME

# NOTE: --privileged needed to support mount
docker run --privileged --name $IMAGE_NAME activescott/$IMAGE_NAME:$TAGNAME

echo "Running activescott/$IMAGE_NAME:$TAGNAME complete. Running logs:"

docker logs -f $IMAGE_NAME
