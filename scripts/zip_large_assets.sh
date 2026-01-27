#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$root_dir/animated"
dest_dir="$root_dir/archives/animated"

if ! command -v zip >/dev/null 2>&1; then
  echo "zip is required but not installed." >&2
  exit 1
fi

if [[ ! -d "$source_dir" ]]; then
  echo "No animated directory found at $source_dir" >&2
  exit 1
fi

mkdir -p "$dest_dir"

shopt -s nullglob
files=("$source_dir"/*.gif "$source_dir"/*.mp4)
shopt -u nullglob

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No animated files found in $source_dir"
  exit 0
fi

for file in "${files[@]}"; do
  base=$(basename "$file")
  zip_path="$dest_dir/${base}.zip"
  if [[ ! -f "$zip_path" || "$file" -nt "$zip_path" ]]; then
    zip -9 -q -j "$zip_path" "$file"
    echo "Updated $zip_path"
  fi
done
