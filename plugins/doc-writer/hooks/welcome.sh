#!/usr/bin/env bash
# SessionStart hook for hello-plugin.
# Prints a one-line hint so the user knows the plugin is loaded.
# Replace this with whatever lightweight setup or check your plugin needs.

set -euo pipefail

echo "[hello-plugin] loaded — try '/hello' for a quick repo orientation."
