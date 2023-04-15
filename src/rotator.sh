OPTIONS=(
  "cloudflare"
)
CHOICE=$(gum choose "${OPTIONS[@]}")

AUTH_TOKEN() { gum input --char-limit=0 --placeholder="Insert the token to be used to authenticate with the API" --password; }

ROTATE_CLOUDFLARE_TOKEN() {
  AUTH_TOKEN=$(AUTH_TOKEN)
  LIST_CURRENT_TOKENS() {
    curl -s "https://api.cloudflare.com/client/v4/user/tokens" \
      -X GET \
      -H "Authorization: Bearer $AUTH_TOKEN" \
      -H 'Content-Type: application/json' |
      jq '.result[] | "\(.id) - \(.name)"'
  }
  IDENTIFIER=$(LIST_CURRENT_TOKENS | xargs gum choose --header="Pick the token to rotate" | cut -d ' ' -f1)
  curl -s "https://api.cloudflare.com/client/v4/user/tokens/$IDENTIFIER/value" \
    -X PUT \
    -H "Authorization: Bearer $AUTH_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{}'
}

case "$CHOICE" in
cloudflare)
  ROTATE_CLOUDFLARE_TOKEN
  ;;
esac
