#/bin/env bash 


# standard rpc api: https://ethereum.org/en/developers/docs/apis/json-rpc
curl k8s.activescott.com:9045 \
  -X POST \
  -H "Content-Type: application/json" \
  --data '{
      "jsonrpc": "2.0",
      "id": 0,
      "method": "admin_nodeInfo",
      "params": []
    }' \
    | jq
