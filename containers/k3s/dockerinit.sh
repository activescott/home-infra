#!/bin/sh

# Trying to apply this workaround: https://github.com/kubernetes-csi/csi-driver-smb/issues/335#issuecomment-896759440
# Interesting... https://ixday.github.io/post/shared_mount/
#echo "runing mount --make-shared on"
#/bin/aux/mount --make-shared /
#/bin/aux/mount --make-shared /var
#/bin/aux/mount --make-shared /var/lib
/bin/aux/mount --make-shared /var/lib/kubelet

# This will exec the "server" or "agent" CMD from the Dockerfile
exec /bin/k3s "$@"
