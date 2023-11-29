# k8tz: Kubernetes Timezone Controller

See https://github.com/k8tz/k8tz

## Usage Notes

Disable k8tz injection on a pod by adding the following label to the pod:

    annotations:
      k8tz.io/inject: "false"
