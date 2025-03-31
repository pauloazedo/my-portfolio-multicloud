#!/bin/bash
set -eo pipefail

# Accept the SECRET_ID and PROFILE as arguments
SECRET_ID="$1"
PROFILE="$2"  # Profile passed as the second argument
MAX_RETRIES=5
DELAY=3

# Attempt to fetch the secret
for ((i = 1; i <= MAX_RETRIES; i++)); do
  if output=$(oci secrets secret-bundle get \
    --secret-id "$SECRET_ID" \
    --profile "$PROFILE" \
    --query 'data."secret-bundle-content".content' \
    --raw-output 2>/dev/null); then

    # Decode and return the secret
    decoded_content=$(echo "$output" | base64 --decode)
    echo "$decoded_content"
    exit 0
  else
    echo "Attempt $i failed. Retrying in ${DELAY}s..." >&2
    sleep "$DELAY"
  fi
done

# If the secret can't be fetched after retries, fail the script
echo "Failed to fetch secret from OCI Vault after $MAX_RETRIES attempts." >&2
exit 1