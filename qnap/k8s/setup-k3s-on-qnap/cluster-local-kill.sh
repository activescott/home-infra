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

echo "Shutting down cluster containers..."
docker-compose -f $COMPOSE_FILE --project-name $COMPOSE_PROJECT down

echo "Removing cluster containers..."
docker-compose -f $COMPOSE_FILE --project-name $COMPOSE_PROJECT rm

while true; do
    printf "\n"
    read -p "Do you want to remove cluster volumes (yes/y or no/n)" yn
    case $yn in
        [Yy]* )
        echo "Removing cluster volumes..."
        docker volume rm $COMPOSE_PROJECT_k3s-kubelet-agent
        docker volume rm $COMPOSE_PROJECT_k3s-kubelet-server
        docker volume rm $COMPOSE_PROJECT_k3s-server
        break;;
        [Nn]* )
        echo "Skipping removing cluster volumes..."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

