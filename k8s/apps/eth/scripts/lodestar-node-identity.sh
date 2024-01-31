#/bin/env bash 

# standard beacon/consensus rpc api: https://ethereum.github.io/beacon-APIs/#/
curl http://k8s.activescott.com:9596/eth/v1/node/identity \
  -X GET \
  -H "Content-Type: application/json" \
    | jq
