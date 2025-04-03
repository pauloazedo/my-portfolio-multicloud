#!/bin/bash

# Usage: ./slack-certbot-alert.sh <webhook_url> <domain>

WEBHOOK_URL="$1"
DOMAIN="$2"
RENEWED_ON="$(date '+%Y-%m-%d %H:%M:%S')"

# Safety check for missing arguments
if [[ -z "$WEBHOOK_URL" || -z "$DOMAIN" ]]; then
  echo "Error: Missing webhook URL or domain."
  echo "Usage: $0 <webhook_url> <domain>"
  exit 1
fi

# Send alert to Slack
curl -s -X POST -H 'Content-type: application/json' --data "{
  \"text\": \":lock: Certificate for *${DOMAIN}* was renewed successfully at \`${RENEWED_ON}\`.\"
}" "$WEBHOOK_URL" > /dev/null