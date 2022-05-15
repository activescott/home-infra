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
USAGE: $THISSCRIPT [COMPOSE_FILE]

END_DOC

}

COMPOSE_PROJECT=myk3s

COMPOSE_FILE_DEFAULT=
if [ -z "$COMPOSE_FILE" ]; then
  # see if one is maybe an argument:
  if [ -f "$1" ]; then
    COMPOSE_FILE_DEFAULT=$1
  else
    # choose a defeault if we can find one:
    for f in k3s-docker-compose-resolved-at-*.yaml; do 
      COMPOSE_FILE_DEFAULT=`basename $f`
      break
    done
  fi
  # prompt for one:
  echo -n "Enter docker compose file to use for the k3s cluster and press [ENTER] (default: $COMPOSE_FILE_DEFAULT):"
  read COMPOSE_FILE
  [ -z "$COMPOSE_FILE" ] && COMPOSE_FILE=$COMPOSE_FILE_DEFAULT
fi

[ -z "$COMPOSE_FILE" ] && die "You must specify a COMPOSE_FILE as the first argument or choose one."

echo "Using compose file $COMPOSE_FILE"
