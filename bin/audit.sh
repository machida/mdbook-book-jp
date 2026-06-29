#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $0 /path/to/mdbook-project" >&2
  exit 1
fi

target_dir="$1"
script_dir="$(cd "$(dirname "$0")/.." && pwd)"
book_toml="$target_dir/book.toml"
core_css="$target_dir/theme/mdbook-book-core.css"
jp_css="$target_dir/theme/mdbook-book-jp.css"

if [ ! -f "$book_toml" ]; then
  echo "book.toml not found: $book_toml" >&2
  exit 1
fi

if [ ! -f "$core_css" ]; then
  echo "missing theme file: $core_css" >&2
  exit 1
fi

if [ ! -f "$jp_css" ]; then
  echo "missing theme file: $jp_css" >&2
  exit 1
fi

python3 - "$book_toml" "$core_css" "$jp_css" "$script_dir" <<'PY'
from pathlib import Path
import ast
import re
import sys

book_toml = Path(sys.argv[1])
target_core = Path(sys.argv[2])
target_jp = Path(sys.argv[3])
source_dir = Path(sys.argv[4]) / "theme"

text = book_toml.read_text(encoding="utf-8")
match = re.search(r'^\s*additional-css\s*=\s*\[(.*?)\]\s*$', text, re.M | re.S)
if not match:
    raise SystemExit("missing additional-css in [output.html]")

items = ast.literal_eval("[" + match.group(1).strip() + "]") if match.group(1).strip() else []
expected = ["theme/mdbook-book-core.css", "theme/mdbook-book-jp.css"]

if items[:2] != expected:
    raise SystemExit(
        "additional-css must start with "
        + str(expected)
        + ", got "
        + str(items[:2])
    )

target_jp_text = target_jp.read_text(encoding="utf-8")
if '@import "./mdbook-book-core.css";' in target_jp_text:
    raise SystemExit(
        "theme/mdbook-book-jp.css still contains @import. Re-run bin/update.sh."
    )

source_core = (source_dir / "mdbook-book-core.css").read_text(encoding="utf-8")
source_jp = (source_dir / "mdbook-book-jp.css").read_text(encoding="utf-8")
if target_core.read_text(encoding="utf-8") != source_core:
    raise SystemExit("theme/mdbook-book-core.css is out of sync with mdbook-book-jp")
if target_jp.read_text(encoding="utf-8") != source_jp:
    raise SystemExit("theme/mdbook-book-jp.css is out of sync with mdbook-book-jp")

print("mdbook-book-jp audit passed")
PY
