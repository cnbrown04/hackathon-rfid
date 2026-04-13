#!/usr/bin/env bash
# Heroku: hackathon-api (Node server) + hackathon-web (tour-frontend).
# Requires: Heroku CLI, logged in (`heroku login`), apps already created with these names.
#
# If apps live under a Heroku team (e.g. `heroku apps -t auburn-rfid-lab`), set:
#   export HEROKU_TEAM=auburn-rfid-lab
#
# Usage:
#   ./scripts/heroku-deploy.sh remotes    # add git remotes heroku-api / heroku-web
#   ./scripts/heroku-deploy.sh bootstrap # one-time buildpacks + PROJECT_PATH + VITE_* for web
#   ./scripts/heroku-deploy.sh push       # git push current branch to both Heroku remotes (deploys)
#
# Set on hackathon-api (dashboard or CLI): DATABASE_URL, ADMIN_PASSWORD, etc.

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Use the exact names from `heroku apps` (Heroku adds a suffix if the base name is taken).
API_APP=hackathon-api
WEB_APP=hackathon-web

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
  git remote get-url heroku-api >/dev/null 2>&1 || git remote add heroku-api "https://git.heroku.com/${API_APP}.git"
  git remote get-url heroku-web >/dev/null 2>&1 || git remote add heroku-web "https://git.heroku.com/${WEB_APP}.git"
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
  echo "If the browser reports CORS on login, verify the API is really yours (Heroku HTML = wrong host or app not deployed):"
  echo "  curl -sI \"${api_url}/health\""
  echo "Redeploy ${WEB_APP} after API URL changes (rename app, custom domain): re-run bootstrap or config:set VITE_API_URL / VITE_WS_URL."
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
  push) cmd_push ;;
  *)
    echo "Usage: $0 remotes | bootstrap | push" >&2
    exit 1
    ;;
esac
