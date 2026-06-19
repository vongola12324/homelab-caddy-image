#!/bin/sh

set -eu

ARGS=""

while IFS= read -r module || [ -n "$module" ]; do
  # Skip empty lines
  [ -z "$module" ] && continue

  # Skip comments
  case "$module" in
  \#*) continue ;;
  esac

  ARGS="$ARGS --with $module"
done <modules.txt

echo "========================================"
echo "Building Caddy with modules:"
echo "$ARGS"
echo "========================================"

# shellcheck disable=SC2086
xcaddy build $ARGS
