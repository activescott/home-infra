#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

# NOTE: install esphome via homebrew
esphome dashboard "$THISDIR/config"

