#!/usr/bin/env bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

# set image
IMAGE_NAME=`basename $PWD`
# /set image

# set tag
TAGNAME=$1
TAGNAME_DEFAULT=v0.1
if [ -z "$TAGNAME" ]; then
  echo -n "Enter TAG name to build and/or publish and press [ENTER] ($TAGNAME_DEFAULT):"
  read TAGNAME
  [ -z "$TAGNAME" ] && TAGNAME=$TAGNAME_DEFAULT
fi
echo "Tag name is: $TAGNAME"
# /set tag
