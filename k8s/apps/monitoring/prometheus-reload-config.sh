#!/usr/bin/env bash

# note: since switching to kustomize configMapGenerator this is probably not usually needed since kustomize adds a hash name to each configmap to get the pod to reload it.
curl -X POST https://prometheus.activescott.com/-/reload