#!/usr/bin/env bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

source "$THISDIR/_set-image-and-tag.sh"

# first rebuild it:
"$THISDIR/build.sh" $TAGNAME



# also tag it with latest
echo "Adding 'latest' tag to activescott/$IMAGE_NAME:$TAGNAME..."

docker tag activescott/$IMAGE_NAME:$TAGNAME activescott/$IMAGE_NAME:latest

echo "Publishing activescott/$IMAGE_NAME:$TAGNAME..."
docker push activescott/$IMAGE_NAME:$TAGNAME

echo "Publishing activescott/$IMAGE_NAME:latest..."

docker push activescott/$IMAGE_NAME:latest

echo "Publishing activescott/$IMAGE_NAME complete."
