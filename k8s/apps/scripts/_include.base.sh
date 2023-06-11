#!/usr/bin/env sh

# Check if THISDIR environment variable is defined
if [[ -z "$THISDIR" ]]; then
    echo "ERROR: THISDIR environment variable is not defined."
    exit 1
fi

help () {
  echo 
  cat << END_DOC
USAGE: $THISSCRIPT K8S_APP_NAME

END_DOC

}

die () {
    echo "*** ERROR ***"
    echo >&2 "ERROR: $@"
    help
    exit 1
}
