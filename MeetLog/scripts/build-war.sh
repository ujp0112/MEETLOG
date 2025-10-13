#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src/main/java"
RESOURCES_DIR="$PROJECT_ROOT/src/main/resources"
WEBAPP_DIR="$PROJECT_ROOT/src/main/webapp"
LIB_DIR="$PROJECT_ROOT/lib"
BUILD_ROOT="$PROJECT_ROOT/build/deploy"
CLASSES_DIR="$BUILD_ROOT/classes"
WORK_DIR="$PROJECT_ROOT/build/deploy/MeetLog"
WAR_FILE="$PROJECT_ROOT/build/deploy/MeetLog.war"

# --- Standard Java checks ---
command -v javac >/dev/null 2>&1 || {
  echo "error: javac not found. Install JDK 11 or later and ensure it is on PATH." >&2
  exit 1
}
command -v jar >/dev/null 2>&1 || {
  echo "error: jar not found. Install JDK 11 or later and ensure it is on PATH." >&2
  exit 1
}

# --- Clean up previous builds ---
rm -rf "$CLASSES_DIR" "$WORK_DIR" "$WAR_FILE"
mkdir -p "$CLASSES_DIR" "$WORK_DIR"

# --- Source file list generation (WINDOWS COMPATIBLE) ---
SOURCES_FILE="$BUILD_ROOT/.sources.txt"
trap 'rm -f "$SOURCES_FILE"' EXIT

echo "Finding Java source files..."
# Find Unix-style paths and convert them to a list of Windows-style paths for javac
find "$SRC_DIR" -name '*.java' | cygpath -w -f - > "$SOURCES_FILE"

# --- Compilation step ---
if [ -s "$SOURCES_FILE" ]; then
  echo "Compiling Java sources..."
  
  # Check for TOMCAT_HOME environment variable
  : "${TOMCAT_HOME:?Set TOMCAT_HOME to your local Tomcat installation directory}"

  # 1. Create a Unix-style classpath string (with ':' separator)
  POSIX_CP="$LIB_DIR/*:$TOMCAT_HOME/lib/*:$RESOURCES_DIR"

  # 2. Convert the Unix-style classpath to a Windows-style one (using ';' as separator)
  WINDOWS_CP=$(cygpath -pw "$POSIX_CP")

  # 3. Compile using the Windows-style classpath and the file list containing Windows-style paths
  javac \
    -encoding UTF-8 \
    -cp "$WINDOWS_CP" \
    -d "$CLASSES_DIR" \
    @"${SOURCES_FILE}"
else
  echo "No Java sources found under $SRC_DIR"
fi

# --- Resource and Webapp copying (Replaced rsync with cp) ---
if [ -d "$RESOURCES_DIR" ]; then
  echo "Copying resources..."
  cp -r "$RESOURCES_DIR"/* "$CLASSES_DIR"/
fi

echo "Preparing web resources..."
cp -r "$WEBAPP_DIR"/* "$WORK_DIR"/

mkdir -p "$WORK_DIR/WEB-INF/classes"
cp -r "$CLASSES_DIR"/* "$WORK_DIR/WEB-INF/classes"/

if compgen -G "$LIB_DIR/*.jar" >/dev/null; then
  mkdir -p "$WORK_DIR/WEB-INF/lib"
  cp -r "$LIB_DIR"/* "$WORK_DIR/WEB-INF/lib/"
fi

# --- WAR packaging ---
echo "Packaging WAR..."
mkdir -p "$(dirname "$WAR_FILE")"
jar cf "$WAR_FILE" -C "$WORK_DIR" .

echo "WAR created at $WAR_FILE"

