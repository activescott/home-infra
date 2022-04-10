# Based on https://github.com/k3s-io/k3s/blob/master/package/Dockerfile
# Trying to prevent https://github.com/kubernetes-csi/csi-driver-smb/issues/191
# https://hub.docker.com/r/rancher/k3s
FROM rancher/k3s

COPY dockerinit.sh /usr/bin/dockerinit.sh
RUN chmod +x /usr/bin/dockerinit.sh

ENTRYPOINT ["/usr/bin/dockerinit.sh"]
CMD ["agent"]
