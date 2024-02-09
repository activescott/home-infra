#/bin/env bash 

# https://docs.nethermind.io/monitoring/health-check

curl -X GET 'k8s.activescott.com:9045/health' \
  -H "Content-Type: application/json" \
  | jq
