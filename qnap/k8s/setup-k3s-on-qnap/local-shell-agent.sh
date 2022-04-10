#!/usr/bin/env sh
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

die () {
    echo >&2 "$@"
    help
    exit 1
}

help () {
  echo 
  cat << END_DOC
USAGE: $THISSCRIPT [OPTIONS] COMPOSE_FILE

Creates the K3S_TOKEN value and version and generates the final docker-compose 
output on the screen with the environment variables substituted. 
See https://docs.docker.com/compose/environment-variables/ for more info.

END_DOC

}

TSTAMP=$(date +"%Y%m%d%H%M%s")

COMPOSE_FILE=$1
[ -z "$COMPOSE_FILE" ] && die "COMPOSE_FILE must be specified as the composefilename to use!"

docker compose -f $COMPOSE_FILE exec agent /bin/sh
