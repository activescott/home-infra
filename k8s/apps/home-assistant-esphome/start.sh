#!/usr/bin/env bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

# NOTE: install esphome via homebrew
esphome dashboard "$THISDIR/config"

