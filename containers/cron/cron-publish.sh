#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
pushd .
cd $THISDIR

echo -n "Enter TAG name to publish and press [ENTER]: "
read TAGNAME
echo "Tag name is: $TAGNAME"

# first rebuild it:
docker build -f cron.Dockerfile -t activescott/cron:$TAGNAME $THISDIR

docker push activescott/cron:$TAGNAME

