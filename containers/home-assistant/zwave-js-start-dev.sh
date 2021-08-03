#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory

# This doesn't end up working well because:
# 1. We have devices mapped on QNAP and those devices aren't available in local dev
# 2. Can use overrides for docker-compose.yml files, but you cannot remove multi-value attributes like devices: https://docs.docker.com/compose/extends/#understanding-multiple-compose-files
# 3. Could have no devices in a base compose, and an override for qnap and an override for dev and then use `docker-compose -f ...yml -f ...override.yml config` to see whole config, but this seems even more complicated :/
# 🤷‍♂️ So I use docker start... below
#docker-compose -f ./home-assitant-docker-compose.yml -f ./home-assitant-docker-compose.dev-overrides.yml up

#echo "Creating..."
#docker container create zwave-js-server --name zjs

echo "Starting..."
docker rm zjs
# to add a device (macOS w/ Silicon Labs' CP210x USB to UART Bridge VCP Drivers):
#--device '/dev/tty.GoControl_zwave:/dev/zwave'
docker run -v "$THISDIR/cache-zwave-js:/cache" -v "$THISDIR/config-zwave-js:/config" --name zjs zwave-js-server 
