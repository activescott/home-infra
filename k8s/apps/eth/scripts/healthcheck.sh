#/bin/env bash 

# erigon is a fork of geth and seems to support most of the geth stuff: 
# geth API: https://geth.ethereum.org/docs/interacting-with-geth/rpc/ns-admin
# standard rpc api: https://ethereum.org/en/developers/docs/apis/json-rpc
# erigon API docs: 
#   - https://github.com/ledgerwatch/erigon#grpc-ports
#   - https://github.com/ledgerwatch/erigon/blob/devel/cmd/rpcdaemon/README.md#rpc-implementation-status
curl --location --request GET 'k8s.activescott.com:9045/health' \
  -X GET \
  -H "Content-Type: application/json" \
  --header 'X-ERIGON-HEALTHCHECK: min_peer_count10' \
  --header 'X-ERIGON-HEALTHCHECK: synced' \
  --header 'X-ERIGON-HEALTHCHECK: max_seconds_behind600' \
  | jq