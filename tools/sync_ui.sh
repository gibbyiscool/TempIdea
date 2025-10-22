#!/usr/bin/env bash
set -euo pipefail
SRC_DIR="${1:-editor/export_c}"   # adjust to your editor's export folder
DST_DIR="firmware/ui"
mkdir -p "$DST_DIR"
if command -v rsync >/dev/null 2>&1; then
  rsync -av --include="*/" --include="*.c" --include="*.h" --exclude="*" "$SRC_DIR/" "$DST_DIR/"
else
  find "$SRC_DIR" -type f \( -name "*.c" -o -name "*.h" \) -exec cp {} "$DST_DIR"/ \;
fi
echo "✅ UI synced to $DST_DIR"
