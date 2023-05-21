# Renewing Let's Encrypt Certificates with Kubernetes CronJobs

This is a Kubernetes CronJob that uses a CronJob load Let's Encrypt certificates that are on disk and update a Kubernetes Secret with the certificates from file so that they can be used in a Service or Ingress.

## Overview

The CronJob runs a script that performs the following steps:

1. Install `kubectl` in an Alpine Linux container
2. Retrieve the Let's Encrypt certificates from a mounted volume
3. Encode the certificates as base64
4. Update a Kubernetes Secret with the base64-encoded certificates

The CronJob is scheduled to run once per day, and updates the Kubernetes Secret with the new certificates if they have been updated by Let's Encrypt.

## Usage

To use this as the cert we can use it in a service as follows:

TODO: show ingress and rolebinding needed! See photoprism