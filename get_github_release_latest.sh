#!/usr/bin/env bash
# Script to download asset file from tag release using GitHub API v3.
# See: http://stackoverflow.com/a/35688093/55075
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# Check dependencies.
set -e
type curl grep sed tr >&2
xargs=$(which gxargs || which xargs)

# Validate settings.
[ $# -ne 4 ] && { echo "Usage: $0 [owner] [repo] [asset_name] [token]"; exit 1; }
read owner repo asset_name GITHUB_API_TOKEN <<<$@
[ -f ~/.secrets ] && source ~/.secrets
[ "$GITHUB_API_TOKEN" ] || { echo "Error: Please define GITHUB_API_TOKEN variable." >&2; exit 1; }
[ "$TRACE" ] && set -x

# Define variables.
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$owner/$repo"
GH_RELEASE="$GH_REPO/releases/latest"
AUTH="Authorization: Bearer $GITHUB_API_TOKEN"
HEADER_API_VERSION="X-GitHub-Api-Version: 2022-11-28"
HEADER_ACCEPT_JSON="Accept: application/vnd.github+json"
HEADER_ACCEPT_STREAM="Accept: application/octet-stream"
WGET_ARGS="--content-disposition --auth-no-challenge --no-cookie"
CURL_ARGS="-LJO#"

# Validate token.
curl -o /dev/null -sH "$AUTH" $GH_REPO || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

# Read asset tags.
response=$(curl -sH "$AUTH" -H "$HEADER_API_VERSION" -H "$HEADER_ACCEPT_JSON" $GH_RELEASE)
# Get ID of the asset based on given name.
eval $(echo "$response" | grep -C3 "name.:.\+$name" | grep -w id | tr : = | tr -cd '[[:alnum:]]=')
#id=$(echo "$response" | jq --arg name "$name" '.assets[] | select(.name == $name).id') # If jq is installed, this can be used instead.
[ "$id" ] || { echo "Error: Failed to get asset id, response: $response" | awk 'length($0)<100' >&2; exit 1; }
GH_ASSET="$GH_REPO/releases/assets/$id"

# Download asset file.
echo "Downloading asset..." >&2
curl $CURL_ARGS -H "$AUTH" -H "$HEADER_ACCEPT_STREAM" "$GH_ASSET"
echo "$0 done." >&2