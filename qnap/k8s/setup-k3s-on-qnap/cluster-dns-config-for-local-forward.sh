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

Patches the CoreDNS configuration (which is referred to as a Corefile stored as a K8S ConfigMap resource).
First it retreives the current configmap and overwrites the forward entry.
Based on https://devops.stackexchange.com/a/6521/30875
END_DOC

}

# DNS Server we want to forward to:
DNS_FORWARDER=10.1.111.1

# Write the old configmap to a local file:
echo "Fetching existing configuration and preparing new configuration..."
TSTAMP=$(date +"%Y%m%d%H%M%s")
OLDFILE="cluster-dns-configmap-old-$TSTAMP.yaml"
NEWFILE="cluster-dns-configmap-new-$TSTAMP.yaml"
kubectl get configmap -n kube-system coredns -o yaml > "$OLDFILE"
cat "$OLDFILE" | sed "s/forward.*$/forward . $DNS_FORWARDER/g" > "$NEWFILE"


echo; echo "Below is the diff of the config changes:"
diff -u "$OLDFILE" "$NEWFILE"

echo; read -p "Ready to overwrite DNS config? Press [ENTER] to continue or [CTRL+C] to exit."
kubectl apply -f "$NEWFILE"
