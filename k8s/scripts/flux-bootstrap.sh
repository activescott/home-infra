#!/usr/bin/env bash
this_dir=$(cd $(dirname "$0"); pwd) # this script's directory
this_script=$(basename $0)

# THIS SCRIPT PER https://fluxcd.io/flux/installation/bootstrap/github/#github-pat

# get the GITHUB_TOKEN:
source "$this_dir/.env.flux.github-pat.secret"

#echo "GITHUB_TOKEN: $GITHUB_TOKEN"

flux bootstrap github \
  --token-auth \
  --owner=activescott \
  --repository=home-infra-k8s-flux \
  --branch=main \
  --path=clusters/nas1 \
  --personal
