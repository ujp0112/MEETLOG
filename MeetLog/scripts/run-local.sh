#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_SCRIPT="$PROJECT_ROOT/scripts/build-war.sh"
WAR_PATH="$PROJECT_ROOT/build/deploy/MeetLog.war"

: "${TOMCAT_HOME:?Set TOMCAT_HOME to your local Tomcat installation directory}"

shutdown_tomcat() {
  if [ -x "$TOMCAT_HOME/bin/shutdown.sh" ]; then
    "$TOMCAT_HOME/bin/shutdown.sh" || true
    sleep 2
  fi
}

startup_tomcat() {
  if [ -x "$TOMCAT_HOME/bin/startup.sh" ]; then
    "$TOMCAT_HOME/bin/startup.sh"
  else
    echo "Tomcat startup script not found at $TOMCAT_HOME/bin/startup.sh" >&2
    exit 1
  fi
}

echo "Building WAR..."
"$BUILD_SCRIPT"

if [ ! -f "$WAR_PATH" ]; then
  echo "WAR not found at $WAR_PATH" >&2
  exit 1
fi

TARGET_WAR="$TOMCAT_HOME/webapps/MeetLog.war"
TARGET_DIR="${TARGET_WAR%.war}"

echo "Stopping Tomcat (if running)..."
shutdown_tomcat

echo "Deploying WAR to $TARGET_WAR"
rm -rf "$TARGET_DIR"
cp "$WAR_PATH" "$TARGET_WAR"

echo "Starting Tomcat..."
startup_tomcat

echo "Tomcat started. Visit http://127.0.0.1:8080/MeetLog"
