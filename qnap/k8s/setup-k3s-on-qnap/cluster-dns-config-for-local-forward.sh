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

# DNS Server we want to forward to:
DNS_FORWARDER=10.1.111.1

source "$THISDIR/.env"

echo "Applying configmap/coredns-custom..."
cat << EOF | kubectl -n=kube-system apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom
data:
  coredns_custom_forward.server: |
  
    activenet {
      forward . 10.1.111.1
    }

EOF

echo; read -p "Begin validation? Press [ENTER] to continue or [CTRL+C] to exit:"

##### VALIDATE #####
# How do we validate it worked?
# create a simple job and have it resolve bitbox.activenet:
JOB_NAME=dns-test-job

cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: $JOB_NAME
spec:
  activeDeadlineSeconds: 15
  # clean up the job after completion:
  ttlSecondsAfterFinished: 15
  backoffLimit: 2
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: example-container
          image: k8s.gcr.io/busybox
          command:
            - '/bin/sh'
          args:
            - '-c'
            - 'nslookup bitbox.activenet'
            #- 'nslookup ddg.gg'
      dnsPolicy: ClusterFirst
      #dnsPolicy: None
      #dnsConfig:
      #  nameservers:
      #    - 10.1.111.1
EOF

SECS=3
while [ $SECS -gt 0 ]; do
  printf "waiting $SECS seconds\n"
  sleep 1
  SECS=`expr $SECS - 1`
done

kubectl logs "job/$JOB_NAME"
##### /VALIDATE #####