#!/usr/bin/env bash

set -Eeuf -o pipefail

get_access_token() {
  local request_token access_token
  request_token=$(
    curl --silent https://getpocket.com/v3/oauth/request \
      --request POST \
      --header "Content-Type: application/json" \
      --header "X-Accept: application/json" \
      --data '{
          "consumer_key": "'"${CONSUMER_KEY}"'",
          "redirect_uri": "https://n8henrie.com"
        }' |
      jq --raw-output '.code'
  )

  open -a firefox "https://getpocket.com/auth/authorize?request_token=${request_token}&redirect_uri=https://n8henrie.com"
  read -r -p "Hit enter after authorizing in browser... " < "$(tty 0>&2)"

  access_token=$(
    curl --silent https://getpocket.com/v3/oauth/authorize \
      --request POST \
      --header "Content-Type: application/json" \
      --header "X-Accept: application/json" \
      --data '{
        "consumer_key": "'"${CONSUMER_KEY}"'",
        "code": "'"${request_token}"'"
      }' |
      jq --raw-output '.access_token'
  )

  printf 'Consider exporting the access token to save time:
    export ACCESS_TOKEN=%s\n' "${access_token}"
  ACCESS_TOKEN=${access_token}
}

main() {
  source ./config.env
  [[ -z "${ACCESS_TOKEN:-}" ]] && get_access_token

  local urls
  mapfile -t urls

  local actions
  actions=$(
    jq --raw-input --null-input --raw-output '[inputs | 
      {
        "action" : "add",
        "url": .,
      }
    ]' <<< "$(printf '%s\n' "${urls[@]}")"
  )
  curl https://getpocket.com/v3/send \
    --request POST \
    --header "Content-Type: application/json" \
    --header "X-Accept: application/json" \
    --data '{
        "consumer_key": "'"${CONSUMER_KEY}"'",
        "access_token": "'"${ACCESS_TOKEN}"'",
        "actions": '"${actions}"'
    }'
}
main "$@"
