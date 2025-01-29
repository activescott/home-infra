#!/usr/bin/env bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

pushd .
cd "$THISDIR"

npx prettier -w "$THISDIR"

popd
