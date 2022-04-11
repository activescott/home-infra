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

# I TRIED more sane stuff but the most repeatable thing would be to just copy the files to the remote host and execute them there.

echo "TODO: just copy the scripts from this directory to the remote host and use those!"
exit

SSH_HOST=scott@bitbox
# setup an SSH ControlMaster socket that other SSH connections can use:
CONTROL_PATH=~/.ssh/%r@%h-%p

echo "setting up SSH ControlMaster..."
# -f: background
# -M: ControlMaster
# -S: The socket path that other ssh instances will also use to connect via this ControlMaster.
ssh -f -M  -S $CONTROL_PATH -o ControlMaster=yes -o ControlPersist=120 $SSH_HOST /bin/bash

# Check the SSH ControlMaster is running:
ssh -S $CONTROL_PATH -o ControlMaster=no $SSH_HOST -O 'check'
# /setup an SSH ControlMaster

# NOTE: the bash --login... gives an interactive shell that loads the appropriate PATH environment to find docker
#ssh -S "$CONTROL_PATH" "$SSH_HOST" "bash --login -c 'set'"





# Copy the docker-compose file there:
echo; echo "Copying compose file to remote host..."
rsync -v --rsh "ssh -S \"$CONTROL_PATH\"" "$COMPOSE_FILE" "$SSH_HOST:~/"

#copy the expected script to remote:
rsync -v --rsh "ssh -S \"$CONTROL_PATH\"" "$COMPOSE_FILE" "$SSH_HOST:~/"



