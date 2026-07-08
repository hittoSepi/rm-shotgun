#!/usr/bin/env bash
set -euo pipefail

backup_root="${RM_SHOTGUN_BACKUP_DIR:-$HOME/.rm-shotgun-backups}"
raw_root="$backup_root/raw"
archive_root="$backup_root/archive"
pack_after_minutes="${RM_SHOTGUN_PACK_AFTER_MINUTES:-60}"
keep_days="${RM_SHOTGUN_KEEP_DAYS:-30}"

mkdir -p "$raw_root" "$archive_root"

find "$raw_root" -mindepth 1 -maxdepth 1 -type d -mmin +"$pack_after_minutes" | while read -r dir; do
  name="$(basename "$dir")"
  archive="$archive_root/$name.tar.zst"

  if [[ -e "$archive" || -e "$archive_root/$name.tar.gz" ]]; then
    continue
  fi

  echo "[rm-shotgun pack] $dir -> $archive"

  if command -v zstd >/dev/null 2>&1; then
    tar --zstd -cf "$archive" -C "$raw_root" "$name"
  else
    archive="$archive_root/$name.tar.gz"
    tar -czf "$archive" -C "$raw_root" "$name"
  fi

  /bin/rm -rf -- "$dir"
done

find "$archive_root" -type f \( -name "*.tar.zst" -o -name "*.tar.gz" \) -mtime +"$keep_days" -delete
