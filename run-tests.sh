#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PROJECT_DIR="$ROOT_DIR"
REPORT_DIR="$ROOT_DIR/test-results"
BACKEND_RESULTS_DIR="$PROJECT_DIR/build/test-results/test"

mkdir -p "$REPORT_DIR"
rm -rf "$REPORT_DIR"/*

cd "$PROJECT_DIR"

GRADLE_CMD=("$PROJECT_DIR/gradlew" test --no-daemon)
if [ -n "${JAVA_HOME:-}" ]; then
  GRADLE_CMD+=("-Dorg.gradle.java.home=$JAVA_HOME")
fi

"${GRADLE_CMD[@]}"
EXIT_CODE=$?

if [ -d "$BACKEND_RESULTS_DIR" ]; then
  cp -R "$BACKEND_RESULTS_DIR"/* "$REPORT_DIR"/
fi

if [ $EXIT_CODE -ne 0 ]; then
  echo "Tests finished with failures. JUnit XML reports are available in $REPORT_DIR."
else
  echo "Tests passed. JUnit XML reports are available in $REPORT_DIR."
fi

exit $EXIT_CODE
