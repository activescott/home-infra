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
USAGE: $THISSCRIPT [OPTIONS]

Creates the K3S_TOKEN value and version and generates the final docker-compose 
output on the screen with the environment variables substituted. 
See https://docs.docker.com/compose/environment-variables/ for more info.

END_DOC

}

TSTAMP=$(date +"%Y%m%d%H%M%s")

K3S_VERSION=v1.22.8-k3s1

K3S_TOKEN=${RANDOM}-${RANDOM}-${RANDOM}-${RANDOM}

if [ -f $THISDIR/.env ]; then
  ENV_BACKUP=.env-backup-$TSTAMP
  mv $THISDIR/.env $THISDIR/$ENV_BACKUP
  echo "backed up existing .env file to $ENV_BACKUP"
fi

RESOLVED_COMPOSE_FILE=k3s-docker-compose-resolved-at-$TSTAMP.yaml

docker-compose -f k3s-docker-compose.yaml config > $THISDIR/$RESOLVED_COMPOSE_FILE

echo "generated resolved docker-compose file at $RESOLVED_COMPOSE_FILE"
echo "Now you can use this to start an independent k3s instance in Container Station (or elsewhere :))"
