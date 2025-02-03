#!/usr/bin/env bash
this_dir=$(cd $(dirname "$0"); pwd) # this script's directory
parent_dir=$(cd $(dirname "$this_dir"); pwd) # parent directory

set -euo pipefail

# Check for the secrets file
env_file=".env.github.secrets"
if [ ! -f "$this_dir/$env_file" ]; then
  echo "Error: $this_dir/$env_file not found. Please create it with github_username, github_token, and github_email."
  exit 1
fi

# Load variables from the env file
source "$this_dir/$env_file"

# Verify mandatory variables are set
if [ -z "${github_username}" ] || [ -z "${github_token}" ] || [ -z "${github_email}" ]; then
  echo "Error: github_username, github_token, and github_email must be set in $env_file."
  exit 1
fi

# Calculate the base64-encoded auth string (username:token)
auth=$(echo -d "$github_username:$github_token" | base64)

# Create a temporary docker config JSON file with the registry credentials
config_file=$(mktemp)
cat <<EOF > "${config_file}"
{
  "auths": {
    "ghcr.io": {
      "username": "${github_username}",
      "password": "${github_token}",
      "email": "${github_email}",
      "auth": "${auth}"
    }
  }
}
EOF

# Base64 encode the entire JSON file -- remove any newlines so that it fits in a single YAML line.
dockerconfig_base64=$(cat "${config_file}" | base64 | tr -d '\n')

# Clean up temporary file
rm "${config_file}"

# Generate the Kubernetes Secret YAML
secret_yaml_file="$parent_dir/base/ghcr-secret.yaml"
cat << EOF > "${secret_yaml_file}"
apiVersion: v1
kind: Secret
metadata:
  name: github-container-registry-secret
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: ${dockerconfig_base64}

EOF

echo "Kubernetes secret YAML has been saved to ${secret_yaml_file}."
