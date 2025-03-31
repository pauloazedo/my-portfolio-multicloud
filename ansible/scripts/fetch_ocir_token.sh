#!/bin/bash
set -eo pipefail

PROFILE="DEVOPS"

oci secrets secret-bundle get \
  --secret-id "$1" \
  --profile "$PROFILE" \
  --query 'data."secret-bundle-content".content' \
  --raw-output | base64 --decode