#!/usr/bin/env bash
# Heroku: hackathon-api (Node server) + hackathon-web (tour-frontend).
# Requires: Heroku CLI, logged in (`heroku login`), apps already created with these names.
#
# Usage:
#   ./scripts/heroku-deploy.sh remotes    # add git remotes heroku-api / heroku-web
#   ./scripts/heroku-deploy.sh bootstrap # one-time buildpacks + PROJECT_PATH + VITE_* for web
#   ./scripts/heroku-deploy.sh push       # git push origin main to both apps (deploys)
#
# Set on hackathon-api (dashboard or CLI): DATABASE_URL, ADMIN_PASSWORD, etc.

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

API_APP=hackathon-api
WEB_APP=hackathon-web

cmd_remotes() {
  git remote get-url heroku-api >/dev/null 2>&1 || git remote add heroku-api "https://git.heroku.com/${API_APP}.git"
  git remote get-url heroku-web >/dev/null 2>&1 || git remote add heroku-web "https://git.heroku.com/${WEB_APP}.git"
  echo "Remotes:"
  git remote -v | grep heroku- || true
}

cmd_bootstrap() {
  local api_url="https://${API_APP}.herokuapp.com"
  echo "Configuring ${API_APP} (subdir → apps/server)…"
  heroku stack:set heroku-24 -a "$API_APP" 2>/dev/null || true
  heroku buildpacks:clear -a "$API_APP" || true
  heroku buildpacks:add -a "$API_APP" --index 1 https://github.com/timanovsky/subdir-heroku-buildpack.git
  heroku buildpacks:add -a "$API_APP" --index 2 heroku/nodejs
  heroku config:set -a "$API_APP" PROJECT_PATH=apps/server

  echo "Configuring ${WEB_APP} (subdir → apps/tour-frontend)…"
  heroku stack:set heroku-24 -a "$WEB_APP" 2>/dev/null || true
  heroku buildpacks:clear -a "$WEB_APP" || true
  heroku buildpacks:add -a "$WEB_APP" --index 1 https://github.com/timanovsky/subdir-heroku-buildpack.git
  heroku buildpacks:add -a "$WEB_APP" --index 2 heroku/nodejs
  heroku config:set -a "$WEB_APP" PROJECT_PATH=apps/tour-frontend
  heroku config:set -a "$WEB_APP" VITE_API_URL="$api_url"
  heroku config:set -a "$WEB_APP" VITE_WS_URL="$(printf '%s' "$api_url" | sed 's/^https/wss/')"

  echo ""
  echo "Done. Set secrets on ${API_APP}, e.g.:"
  echo "  heroku config:set -a ${API_APP} DATABASE_URL='postgresql://…' ADMIN_PASSWORD='…'"
  echo "Redeploy ${WEB_APP} after API URL changes (custom domain): update VITE_API_URL / VITE_WS_URL the same way."
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
