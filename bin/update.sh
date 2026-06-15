#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $0 /path/to/mdbook-project" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "$0")/.." && pwd)"
exec "$script_dir/bin/install.sh" "$1"
