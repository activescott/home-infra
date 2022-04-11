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

JOB_NAME=example-ls-job

cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: $JOB_NAME
spec:
  activeDeadlineSeconds: 60
  # clean up the job after completion:
  ttlSecondsAfterFinished: 300
  backoffLimit: 3
  restartPolicy: Never
  template:
    spec:
      containers:
        - name: example-container
          image: k8s.gcr.io/busybox
          command:
            - '/bin/sh'
          args:
            - '-c'
            - 'ls /usr/test-data/'
          volumeMounts:
            - name: my-volume
              mountPath: /usr/test-data
      volumes:
        - name: my-volume
          persistentVolumeClaim:
            claimName: pvc-vol-app-data
    
EOF

