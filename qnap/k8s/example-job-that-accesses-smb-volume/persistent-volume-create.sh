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
USAGE: $THISSCRIPT [OPTIONS] COMMAND

END_DOC

}

source "$THISDIR/.env"

read -p "Make sure you have already run the credentials-create script! Press [ENTER] to continue or [CTRL+C] to exit..."


echo; echo "Creating the PersistentVolume resource"
VOLUME_NAME=vol-app-data
VOLUME_HANDLE=$VOLUME_NAME-handle
VOLUME_SOURCE=//bitbox.activenet/app-data

echo "First deleting any existing volume..."
kubectl delete persistentvolume $VOLUME_NAME

echo "Creating volume..."
cat <<EOF | kubectl apply -f -
# from https://github.com/kubernetes-csi/csi-driver-smb/blob/master/deploy/example/e2e_usage.md
apiVersion: v1
kind: PersistentVolume
metadata:
  name: $VOLUME_NAME
spec:
  capacity:
    storage: 100Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: smb
  mountOptions:
    - dir_mode=0777
    - file_mode=0777
  csi:
    driver: smb.csi.k8s.io
    readOnly: true
    volumeHandle: $VOLUME_HANDLE  # make sure it's a unique id in the cluster
    volumeAttributes:
      source: "$VOLUME_SOURCE"
    nodeStageSecretRef:
      name: smbcreds
      namespace: default
EOF


echo; echo "Creating PersistentVolumeClaim..."

echo "First deleting any existing claim..."
kubectl delete PersistentVolumeClaim "pvc-$VOLUME_NAME"

echo "Creating the claim..."

cat <<EOF | kubectl apply   -f -
# From https://github.com/kubernetes-csi/csi-driver-smb/blob/master/deploy/example/e2e_usage.md
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-$VOLUME_NAME
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi
  volumeName: $VOLUME_NAME
  storageClassName: smb
EOF
