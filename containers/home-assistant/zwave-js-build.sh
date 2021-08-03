#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
pushd .
cd $THISDIR

docker build -f zwave-js-server.Dockerfile -t activescott/zwave-js-server $THISDIR
