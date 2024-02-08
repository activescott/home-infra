#/bin/env bash 

# erigon is a fork of geth and seems to support most of the geth stuff: 
# geth API: https://geth.ethereum.org/docs/interacting-with-geth/rpc/ns-admin
# standard rpc api: https://ethereum.org/en/developers/docs/apis/json-rpc
# erigon API docs: 
#   - https://github.com/ledgerwatch/erigon#grpc-ports
#   - https://github.com/ledgerwatch/erigon/blob/devel/cmd/rpcdaemon/README.md#rpc-implementation-status
curl k8s.activescott.com:9045 \
  -X POST \
  -H "Content-Type: application/json" \
  --data '{
      "jsonrpc": "2.0",
      "id": 1,
      "method": "eth_syncing",
      "params": []
    }' \
    | jq