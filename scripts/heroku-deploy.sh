#!/usr/bin/env bash
# Heroku: CLI app names are hackathon-api + hackathon-web; *.herokuapp.com hostnames may include a Heroku suffix.
# Requires: Heroku CLI, logged in (`heroku login`), apps already created.
#
# If apps live under a Heroku team (e.g. `heroku apps -t auburn-rfid-lab`), set:
#   export HEROKU_TEAM=auburn-rfid-lab
#
# Usage:
#   ./scripts/heroku-deploy.sh remotes         # sync git remotes heroku-api / heroku-web → API_APP / WEB_APP
#   ./scripts/heroku-deploy.sh bootstrap       # one-time buildpacks + PROJECT_PATH + VITE_* for web
#   ./scripts/heroku-deploy.sh config-web-api  # only VITE_API_URL + VITE_WS_URL on WEB_APP (then redeploy web)
#   ./scripts/heroku-deploy.sh push            # git push current branch to both Heroku remotes (deploys)
#
# Set on the API app (dashboard or CLI): DATABASE_URL, ADMIN_PASSWORD, etc.

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# CLI / dashboard app names (`heroku apps`). Override: export API_APP=… WEB_APP=…
API_APP=${API_APP:-hackathon-api}
WEB_APP=${WEB_APP:-hackathon-web}

HEROKU_TEAM=${HEROKU_TEAM:-}

heroku_cli() {
  if [[ -n "${HEROKU_TEAM}" ]]; then
    heroku -t "${HEROKU_TEAM}" "$@"
  else
    heroku "$@"
  fi
}

heroku_app_web_url() {
  local app="$1"
  heroku_cli apps:info -a "$app" --json | python3 -c "import json,sys; j=json.load(sys.stdin); print(j.get('app',{}).get('web_url','').rstrip('/'))"
}

cmd_remotes() {
  if git remote get-url heroku-api >/dev/null 2>&1; then
    git remote set-url heroku-api "https://git.heroku.com/${API_APP}.git"
  else
    git remote add heroku-api "https://git.heroku.com/${API_APP}.git"
  fi
  if git remote get-url heroku-web >/dev/null 2>&1; then
    git remote set-url heroku-web "https://git.heroku.com/${WEB_APP}.git"
  else
    git remote add heroku-web "https://git.heroku.com/${WEB_APP}.git"
  fi
  echo "Remotes:"
  git remote -v | grep heroku- || true
}

cmd_bootstrap() {
  if ! heroku_cli apps:info -a "$API_APP" &>/dev/null; then
    echo "Heroku app '${API_APP}' not found for this account/team." >&2
    echo "Create it or set HEROKU_TEAM (e.g. export HEROKU_TEAM=auburn-rfid-lab), then re-run bootstrap." >&2
    echo "  heroku apps:create ${API_APP} -t <team>   # or set API_APP in this script" >&2
    exit 1
  fi
  if ! heroku_cli apps:info -a "$WEB_APP" &>/dev/null; then
    echo "Heroku app '${WEB_APP}' not found for this account/team. Set HEROKU_TEAM if the app is on a team." >&2
    exit 1
  fi

  local api_url
  api_url="$(heroku_app_web_url "$API_APP")"
  if [[ -z "$api_url" ]]; then
    echo "Could not read web URL for ${API_APP} (heroku apps:info --json)." >&2
    exit 1
  fi

  echo "Configuring ${API_APP} (subdir → apps/server)…"
  heroku_cli stack:set heroku-24 -a "$API_APP" 2>/dev/null || true
  heroku_cli buildpacks:clear -a "$API_APP" || true
  heroku_cli buildpacks:add -a "$API_APP" --index 1 https://github.com/timanovsky/subdir-heroku-buildpack.git
  heroku_cli buildpacks:add -a "$API_APP" --index 2 heroku/nodejs
  heroku_cli config:set -a "$API_APP" PROJECT_PATH=apps/server

  echo "Configuring ${WEB_APP} (subdir → apps/tour-frontend)…"
  heroku_cli stack:set heroku-24 -a "$WEB_APP" 2>/dev/null || true
  heroku_cli buildpacks:clear -a "$WEB_APP" || true
  heroku_cli buildpacks:add -a "$WEB_APP" --index 1 https://github.com/timanovsky/subdir-heroku-buildpack.git
  heroku_cli buildpacks:add -a "$WEB_APP" --index 2 heroku/nodejs
  heroku_cli config:set -a "$WEB_APP" PROJECT_PATH=apps/tour-frontend
  echo "Pointing ${WEB_APP} build at API: ${api_url}"
  heroku_cli config:set -a "$WEB_APP" VITE_API_URL="$api_url"
  heroku_cli config:set -a "$WEB_APP" VITE_WS_URL="$(printf '%s' "$api_url" | sed 's/^https/wss/')"

  echo ""
  echo "Done. Set secrets on ${API_APP}, e.g.:"
  if [[ -n "${HEROKU_TEAM}" ]]; then
    echo "  heroku -t ${HEROKU_TEAM} config:set -a ${API_APP} DATABASE_URL='postgresql://…' ADMIN_PASSWORD='…'"
  else
    echo "  heroku config:set -a ${API_APP} DATABASE_URL='postgresql://…' ADMIN_PASSWORD='…'"
  fi
  echo "Then: ./scripts/heroku-deploy.sh push"
  echo "If the browser reports CORS on login, the preflight often hit Heroku's HTML (e.g. \"No such app\") instead of this Node server — those responses have no Access-Control-Allow-Origin."
  echo "  curl -sI \"${api_url}/health\"   # expect 200 + JSON from Node, not 404 HTML"
  echo "  curl -sI -X OPTIONS \"${api_url}/api/admin/login\" -H 'Origin: https://example.com' -H 'Access-Control-Request-Method: POST' -H 'Access-Control-Request-Headers: content-type'   # expect 204 + access-control-*"
  echo "Redeploy ${WEB_APP} after API URL changes (rename app, custom domain): re-run bootstrap or ./scripts/heroku-deploy.sh config-web-api."
}

cmd_config_web_api() {
  if ! heroku_cli apps:info -a "$API_APP" &>/dev/null; then
    echo "Heroku app '${API_APP}' not found for this account/team." >&2
    exit 1
  fi
  if ! heroku_cli apps:info -a "$WEB_APP" &>/dev/null; then
    echo "Heroku app '${WEB_APP}' not found for this account/team." >&2
    exit 1
  fi
  local api_url
  api_url="$(heroku_app_web_url "$API_APP")"
  if [[ -z "$api_url" ]]; then
    echo "Could not read web URL for ${API_APP}." >&2
    exit 1
  fi
  echo "Setting ${WEB_APP} VITE_API_URL / VITE_WS_URL from ${API_APP} web_url: ${api_url}"
  heroku_cli config:set -a "$WEB_APP" \
    VITE_API_URL="$api_url" \
    VITE_WS_URL="$(printf '%s' "$api_url" | sed 's/^https/wss/')"
  echo "Redeploy ${WEB_APP} (e.g. git push heroku-web) so the Vite build embeds the new values."
}

cmd_push() {
  local branch
  branch="$(git rev-parse --abbrev-ref HEAD)"
  echo "Pushing ${branch} → ${API_APP} and ${WEB_APP}…"
  git push heroku-api "${branch}:main" --force-with-lease
  git push heroku-web "${branch}:main" --force-with-lease
}

case "${1:-}" in
  remotes) cmd_remotes ;;
  bootstrap) cmd_bootstrap ;;
  config-web-api) cmd_config_web_api ;;
  push) cmd_push ;;
  *)
    echo "Usage: $0 remotes | bootstrap | config-web-api | push" >&2
    exit 1
    ;;
esac
