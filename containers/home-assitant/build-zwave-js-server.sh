#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
pushd .
cd $THISDIR

docker build --no-cache -f zwave-js-server.Dockerfile $THISDIR
