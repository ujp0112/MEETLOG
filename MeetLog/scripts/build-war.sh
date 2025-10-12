#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src/main/java"
RESOURCES_DIR="$PROJECT_ROOT/src/main/resources"
WEBAPP_DIR="$PROJECT_ROOT/src/main/webapp"
LIB_DIR="$PROJECT_ROOT/lib"
BUILD_ROOT="$PROJECT_ROOT/build/deploy"
CLASSES_DIR="$BUILD_ROOT/classes"
WORK_DIR="$BUILD_ROOT/MeetLog"
WAR_FILE="$BUILD_ROOT/MeetLog.war"

command -v javac >/dev/null 2>&1 || {
  echo "error: javac not found. Install JDK 11 or later and ensure it is on PATH." >&2
  exit 1
}

command -v jar >/dev/null 2>&1 || {
  echo "error: jar not found. Install JDK 11 or later and ensure it is on PATH." >&2
  exit 1
}

rm -rf "$CLASSES_DIR" "$WORK_DIR" "$WAR_FILE"
mkdir -p "$CLASSES_DIR" "$WORK_DIR"

SOURCES_FILE="$BUILD_ROOT/.sources.txt"
trap 'rm -f "$SOURCES_FILE"' EXIT

find "$SRC_DIR" -name '*.java' -print > "$SOURCES_FILE"

if [ -s "$SOURCES_FILE" ]; then
  echo "Compiling Java sources..."
  javac \
    -encoding UTF-8 \
    -cp "$LIB_DIR/*:$RESOURCES_DIR" \
    -d "$CLASSES_DIR" \
    @"$SOURCES_FILE"
else
  echo "No Java sources found under $SRC_DIR"
fi

if [ -d "$RESOURCES_DIR" ]; then
  echo "Copying resources..."
  rsync -a "$RESOURCES_DIR"/ "$CLASSES_DIR"/
fi

echo "Preparing web resources..."
rsync -a "$WEBAPP_DIR"/ "$WORK_DIR"/

mkdir -p "$WORK_DIR/WEB-INF/classes"
rsync -a "$CLASSES_DIR"/ "$WORK_DIR/WEB-INF/classes"/

if compgen -G "$LIB_DIR/*.jar" >/dev/null; then
  mkdir -p "$WORK_DIR/WEB-INF/lib"
  rsync -a "$LIB_DIR/" "$WORK_DIR/WEB-INF/lib/"
fi

echo "Packaging WAR..."
mkdir -p "$(dirname "$WAR_FILE")"
jar cf "$WAR_FILE" -C "$WORK_DIR" .

echo "WAR created at $WAR_FILE"
