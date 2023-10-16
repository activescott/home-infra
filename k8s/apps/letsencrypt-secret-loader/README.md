# Renewing Let's Encrypt Certificates with Kubernetes CronJobs

This is a Kubernetes CronJob that uses a CronJob load Let's Encrypt certificates that are on disk and update a Kubernetes Secret with the certificates from file so that they can be used in a Service or Ingress.

## TODO: 

**DEPRECATED**: **Remove the last usage of this at `/k8s/apps/photoprism/overlays/scott/patch-photoprism-ingress.yaml` by porting it to cert-manager and delete this.

## Overview

The CronJob runs a script that performs the following steps:

1. Install `kubectl` in an Alpine Linux container
2. Retrieve the Let's Encrypt certificates from a mounted volume
3. Encode the certificates as base64
4. Update a Kubernetes Secret with the base64-encoded certificates

The CronJob is scheduled to run once per day, and updates the Kubernetes Secret with the new certificates if they have been updated by Let's Encrypt.

## Usage

To use this as the cert we can use it in a service via a kustomize patch as follows:

```
resources:
- ...
- ../../letsencrypt-secret-loader

namespace: my-apps-namespace

```
The key point here is to create the CronJob and it's associated ServiceAccount, role, and RoleBinding within your app's namespace. Then it will create the secret within your app's namespace and it will be accessible to your Ingress. 

See photoprism at `/k8s/apps/photoprism/overlays/scott/patch-photoprism-ingress.yaml`