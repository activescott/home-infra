#!/usr/bin/env bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

source "$THISDIR/_set-image-and-tag.sh"

echo; echo "removing any existing activescott/$IMAGE_NAME:$TAGNAME image..."
docker image rm --force activescott/$IMAGE_NAME:$TAGNAME
echo "removing complete."

echo "Building activescott/$IMAGE_NAME:$TAGNAME..."
docker build -f $IMAGE_NAME.Dockerfile -t activescott/$IMAGE_NAME:$TAGNAME $THISDIR
echo "Building activescott/$IMAGE_NAME:$TAGNAME complete."
