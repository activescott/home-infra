#!/usr/bin/env sh

THISDIR=$(cd $(dirname "$0"); pwd) #this script's directory
THISSCRIPT=$(basename $0)

die () {
    echo ""
    echo >&2 "$@"
    help
    exit 1
}

help () {
  echo 
  cat << END_DOC

USAGE: $THISSCRIPT [OPTIONS]

NOTE: This script must be run as the "admin" user to copy into the /etc/stunnel/ directory

END_DOC

}

CERT_PATH=/share/CACHEDEV1_DATA/app-data/letsencrypt/live/activescott.com

# we stage the certs here first:
echo "Gathering certs into staging area..."
STAGE_PATH=$THISDIR/staging
[[ -d "$STAGE_PATH" ]] || mkdir "$STAGE_PATH"
cp "$CERT_PATH/fullchain.pem" "$CERT_PATH/privkey.pem" "$STAGE_PATH/"

# now follow instructions from https://www.qnap.com/en/how-to/knowledge-base/article/how-to-replace-ssl-certificate-manually-on-ssh-console
# also super helpful: https://forum.qnap.com/viewtopic.php?t=122747&start=60#p651727

# replace stunnel.pem by combining cert and private key
echo "Generating stunnel.pem..."
cat "$STAGE_PATH/fullchain.pem" "$STAGE_PATH/privkey.pem" > "$STAGE_PATH/stunnel.pem"

echo "Cleaning up privkey/cert..."
rm -f "$STAGE_PATH/fullchain.pem" "$STAGE_PATH/privkey.pem" || echo "WARN: error cleaning up cert and privkey" 

echo "Copying to /etc/stunnel/stunnel.pem..."
mv -f "$STAGE_PATH/stunnel.pem" "/etc/stunnel/stunnel.pem" || die "failed to copy etc/stunnel/stunnel.pem"
chmod 600 /etc/stunnel/stunnel.pem || die "failed to set permissions on /etc/stunnel/stunnel.pem"

# restart related services:
echo "Restarting services..."
/etc/init.d/Qthttpd.sh restart || echo "WARN: failed to restart Qthttpd"
/etc/init.d/thttpd.sh restart || echo "WARN: failed to restart thttpd" 
/etc/init.d/stunnel.sh restart || echo "WARN: failed to restart stunnel.sh"
