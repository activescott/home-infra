# k8s on qnap

As of [Container Station version 2.5.1.392 (March 21, 2022)](https://www.qnap.com/en-us/app_releasenotes/list.php?app_choose=container-station#f_2680) QNAP supports running a Kubernetes (K3s) on the your QNAP by checking a box. This directory contains a set of projects to experiment with it and see about moving my current docker-compose workloads over to "pure" (CNCF-certified) Kubernetes instance. Goals:

- All deployments are entirely automated.
- Rebooting qnap brings back up all K8S pods/apps/services
- QNAP host remains the primary storage for all persistent storage

## Architecture Overview

### Compute

- The k3s node itself is inside of a docker container on the host. So the qnap native filesystem isn't available for things like `host-storage`. While this will probably introduce some performance issues, it is for the better long term as the k8s-hosted apps/services won't have any dependence on their host node (e.g. for storage).

### Networking Egress/Ingress

explicit ingress? loadbalancer (k3s supports). I'm not sure which i like better. TLS has more control under ingress, but I think it's more hassle to configure.

### Storage

Due to the fact that the k3s node is a vm itself, local-storage storageclass doesn't work and I'm just going to use the following plan:

- ~~each container/pod will have to mount a cifs volume within the container itself~~ - booo that is lame. some containers are built by the software provider (e.g. plex, unifi) and those need raw mounts into the container
- Provide the cifs/samba shares from the qnap as K8S cluster-wide `PersistentStorage` resources and let each pod mount them via `PersistentStorageClaim` (maybe some for read-only and some for read/write?)

## TODO

- Get pods access to the PersistentStorage resources.
- Setup a "test-ls-job" that can mount each NFS-exposed volume and do a ls that shows all the files/dirs in the root of the share.

SEE https://github.com/kubernetes-csi/csi-driver-smb
This looks like the ticket: Install it via helm and then do https://github.com/kubernetes-csi/csi-driver-smb/blob/master/deploy/example/e2e_usage.md
