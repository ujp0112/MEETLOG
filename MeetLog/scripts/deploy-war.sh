#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_WAR_PATH="$PROJECT_ROOT/build/deploy/MeetLog.war"

WAR_PATH="${1:-$DEFAULT_WAR_PATH}"

if [ ! -f "$WAR_PATH" ]; then
  echo "error: WAR not found at $WAR_PATH" >&2
  echo "       Run scripts/build-war.sh first or pass the WAR path explicitly." >&2
  exit 1
fi

: "${DEPLOY_HOST:?Set DEPLOY_HOST to the SSH host (e.g. server.example.com)}"
: "${DEPLOY_USER:?Set DEPLOY_USER to the SSH username}"
: "${DEPLOY_TARGET_DIR:?Set DEPLOY_TARGET_DIR to the Tomcat webapps directory (e.g. /opt/tomcat/webapps)}"

DEPLOY_PORT="${DEPLOY_PORT:-22}"
REMOTE_WAR_NAME="${REMOTE_WAR_NAME:-MeetLog.war}"
if [ -z "${REMOTE_CONTEXT_NAME:-}" ]; then
  REMOTE_CONTEXT_NAME="${REMOTE_WAR_NAME%.war}"
fi
REMOTE_TMP="${REMOTE_TMP:-/tmp/$REMOTE_WAR_NAME}"
TOMCAT_SERVICE="${TOMCAT_SERVICE:-tomcat}"
REMOTE_USE_SUDO="${REMOTE_USE_SUDO:-1}"
REMOTE_OWNER="${REMOTE_OWNER:-}"
REMOTE_GROUP="${REMOTE_GROUP:-}"

SCP_ARGS=(-P "$DEPLOY_PORT")
SSH_ARGS=(-p "$DEPLOY_PORT")

if [ -n "${SSH_KEY_PATH:-}" ]; then
  SCP_ARGS+=(-i "$SSH_KEY_PATH")
  SSH_ARGS+=(-i "$SSH_KEY_PATH")
fi

if [ -n "${SSH_OPTIONS:-}" ]; then
  # shellcheck disable=SC2206
  EXTRA_OPTS=($SSH_OPTIONS)
  SCP_ARGS+=("${EXTRA_OPTS[@]}")
  SSH_ARGS+=("${EXTRA_OPTS[@]}")
fi

echo "Uploading $WAR_PATH to $DEPLOY_USER@$DEPLOY_HOST:$REMOTE_TMP"
scp "${SCP_ARGS[@]}" "$WAR_PATH" "$DEPLOY_USER@$DEPLOY_HOST:$REMOTE_TMP"

read -r -d '' REMOTE_SCRIPT <<EOF || true
set -euo pipefail

TMP_WAR="$REMOTE_TMP"
TARGET_DIR="$DEPLOY_TARGET_DIR"
WAR_NAME="$REMOTE_WAR_NAME"
CONTEXT_NAME="$REMOTE_CONTEXT_NAME"
SERVICE_NAME="$TOMCAT_SERVICE"
USE_SUDO="$REMOTE_USE_SUDO"
OWNER_SPEC="$REMOTE_OWNER"
GROUP_SPEC="$REMOTE_GROUP"

run() {
  if [ "\$USE_SUDO" = "1" ]; then
    sudo "\$@"
  else
    "\$@"
  fi
}

if [ ! -f "\$TMP_WAR" ]; then
  echo "Uploaded WAR not found at \$TMP_WAR" >&2
  exit 1
fi

if [ ! -d "\$TARGET_DIR" ]; then
  echo "Target directory \$TARGET_DIR not found" >&2
  exit 1
fi

if [ -n "\$SERVICE_NAME" ]; then
  run systemctl stop "\$SERVICE_NAME"
fi

if [ -n "\$CONTEXT_NAME" ]; then
  run rm -rf "\$TARGET_DIR/\$CONTEXT_NAME"
fi

run mv "\$TMP_WAR" "\$TARGET_DIR/\$WAR_NAME"

if [ -n "\$OWNER_SPEC" ] || [ -n "\$GROUP_SPEC" ]; then
  OWNER_ARG="\$OWNER_SPEC"
  if [ -n "\$GROUP_SPEC" ]; then
    if [ -n "\$OWNER_ARG" ]; then
      OWNER_ARG="\$OWNER_ARG:\$GROUP_SPEC"
    else
      OWNER_ARG=":\$GROUP_SPEC"
    fi
  fi
  run chown "\$OWNER_ARG" "\$TARGET_DIR/\$WAR_NAME"
fi

if [ -n "\$SERVICE_NAME" ]; then
  run systemctl start "\$SERVICE_NAME"
fi
EOF

echo "Applying remote deployment commands..."
ssh "${SSH_ARGS[@]}" "$DEPLOY_USER@$DEPLOY_HOST" 'bash -s' <<EOF
$REMOTE_SCRIPT
EOF

echo "Deployment complete."
