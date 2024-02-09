#/bin/env bash 


# geth API: https://geth.ethereum.org/docs/interacting-with-geth/rpc/ns-admin
# standard rpc api: https://ethereum.org/en/developers/docs/apis/json-rpc
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