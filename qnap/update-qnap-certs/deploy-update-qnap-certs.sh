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

Commands:
  mycommand     This is an example command.

Options:
  -x     This is an example option

END_DOC

}

##########
# SETUP SSH control master
# break down the remote path into host & path:
SSH_HOST=admin@bitbox
# setup an SSH ControlMaster socket that other SSH connections can use:
CONTROL_PATH=~/.ssh/%r@%h-%p
echo "setting up SSH ControlMaster..."
# -f: background
# -M: ControlMaster
# -S: The socket path that other ssh instances will also use to connect via this ControlMaster.
ssh -f -M  -S $CONTROL_PATH -o ControlMaster=yes -o ControlPersist=30 $SSH_HOST /bin/bash

# Check the SSH ControlMaster is running:
ssh -S $CONTROL_PATH -o ControlMaster=no $SSH_HOST -O 'check'
#
##########

# executes the command remotely via ssh
exec_remote() {
  echo "exec_remote: executing $@"
  ssh -S "$CONTROL_PATH" "$SSH_HOST" $@
}

##########
# deploy the script:
SCRIPT_NAME=update-qnap-certs.sh
DEST_DIR=/share/CACHEDEV1_DATA/app-data/update-qnap-certificate-script

echo "copying script:"

exec_remote mkdir -pv "$DEST_DIR"

RSYNC_OPTIONS="-v --archive"
rsync $RSYNC_OPTIONS --rsh "ssh -S \"$CONTROL_PATH\"" "$THISDIR/$SCRIPT_NAME" "$SSH_HOST:$DEST_DIR/$SCRIPT_NAME"

ssh -S "$CONTROL_PATH" "$SSH_HOST" "/bin/sh" << END_DOC
chmod +x "$DEST_DIR/$SCRIPT_NAME"
ls -l "$DEST_DIR/$SCRIPT_NAME"
END_DOC

#
##########

##########
# update crontab, but preserve jobs already there
CRONTAB_PATH=/etc/config/crontab
STAGING_DIR=$DEST_DIR/staging

ssh -S "$CONTROL_PATH" "$SSH_HOST" "/bin/sh" << END_DOC
cd $DEST_DIR
[[ -d "$STAGING_DIR" ]] && rm -rf "$STAGING_DIR"
[[ -d "$STAGING_DIR" ]] || mkdir -p "$STAGING_DIR"

# sed is used here to delete (/d command) to delete the line(s) containing our script incase it is already there:
cat "$CRONTAB_PATH" | sed "/$SCRIPT_NAME/d" > "$STAGING_DIR/crontab"

# add our line to the crontab in staging dir:
# at 07:00 PM, only on Friday
echo "0 19 * * 5 $DEST_DIR/$SCRIPT_NAME" >> "$STAGING_DIR/crontab"

# copy the revised crontab file to the right place:
echo "new crontab:"
cat "$STAGING_DIR/crontab"

cp -vf "$STAGING_DIR/crontab" "$CRONTAB_PATH"
END_DOC
#
##########

##########
# restart cron daemon
# QNAP cron info: https://wiki.qnap.com/wiki/Add_items_to_crontab
exec_remote crontab "$CRONTAB_PATH"
exec_remote /etc/init.d/crond.sh restart
#
##########
