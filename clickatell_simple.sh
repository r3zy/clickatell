#!/bin/bash
USERNAME=""
PASSWORD=""
API_ID=""
RECIPIENT="$1"
TEXT="$2"
curl -G \
  --data-urlencode user=$USERNAME \
  --data-urlencode password=$PASSWORD \
  --data-urlencode api_id=$API_ID \
  --data-urlencode to=$RECIPIENT \
  --data-urlencode text="$TEXT" \
  "https://api.clickatell.com/http/sendmsg"
