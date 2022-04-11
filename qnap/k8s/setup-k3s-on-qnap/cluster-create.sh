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
USAGE: $THISSCRIPT [OPTIONS] [COMPOSE_FILE]
END_DOC

}

source _resolve-compose-file.sh

docker-compose -f $COMPOSE_FILE --project-name $COMPOSE_PROJECT up --detach 

SECS=10
while [ $SECS -gt 0 ]; do
  printf "waiting $SECS seconds\n"
  sleep 1
  SECS=`expr $SECS - 1`
done

echo "Creating kubectl config file..."
K3S_CONFIG_FILE=k3s-kubectl-config.yaml
TSTAMP=$(date +"%Y%m%d%H%M%s")
[ -f $K3S_CONFIG_FILE ] && mv $K3S_CONFIG_FILE "$K3S_CONFIG_FILE.backup-$TSTAMP"
docker-compose -f $COMPOSE_FILE --project-name $COMPOSE_PROJECT exec server /bin/sh -c 'cat /etc/rancher/k3s/k3s.yaml' > $K3S_CONFIG_FILE
chmod go-r $K3S_CONFIG_FILE
echo "Created kubectl config file at $K3S_CONFIG_FILE"
