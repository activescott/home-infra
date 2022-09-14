#!/bin/bash
THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
BASENAME=$(basename -s .sh "$0") #this script's name

GIT_DIR=$THISDIR
HASS_DIR=admin@bitbox:/share/CACHEDEV1_DATA/app-data/phtotoprism

# break down the remote path into host & path:
HASS_HOST=${HASS_DIR%:*}
HASS_PATH=${HASS_DIR#*:}
# setup an SSH ControlMaster socket that other SSH connections can use:
CONTROL_PATH=~/.ssh/%r@%h-%p

if [ -z "$FILES_TO_DIFF" ];
then
  echo "setting up SSH ControlMaster..."
  # -f: background
  # -M: ControlMaster
  # -S: The socket path that other ssh instances will also use to connect via this ControlMaster.
  ssh -f -M  -S $CONTROL_PATH -o ControlMaster=yes -o ControlPersist=120 $HASS_HOST /bin/bash

  # Check the SSH ControlMaster is running:
  ssh -S $CONTROL_PATH -o ControlMaster=no $HASS_HOST -O 'check'

  # use rsync to get a list of files that are different:
  echo "Checking which files are different..."
  FILES_TO_DIFF=$(rsync -vrn --delete --rsh "ssh -S \"$CONTROL_PATH\"" --exclude-from="rsync-excluded-files" $HASS_DIR/ $GIT_DIR | sed '1d;s/^deleting \(.*\)$/\1/;/^$/q')
  printf "Found files that need diffed: %s\n" "$FILES_TO_DIFF"
  echo ""
fi

echo "Performing diffs..."

for FNAME in $FILES_TO_DIFF; do
  printf "\n##### %s : %s #####\n" "$FNAME" "${HASS_DIR}/${FNAME}"
  if [ -f "${GIT_DIR}/${FNAME}" ];
  then
    diff -u --minimal <(ssh -S "$CONTROL_PATH" "$HASS_HOST" cat "${HASS_PATH}/${FNAME}" || printf "") "${GIT_DIR}/${FNAME}"
  else
    printf "MISSING FILE IN GIT: ${GIT_DIR}/${FNAME}"
  fi
done

echo "Performing diffs complete."
