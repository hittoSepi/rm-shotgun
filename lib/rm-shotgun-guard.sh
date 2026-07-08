# rm-shotgun-guard.sh
# Back up targets before dangerous rm -rf / rm -fr / rm -Rf calls.
# Source this file from an interactive bash/zsh config.

rm() {
  local safety="${RM_SHOTGUN_SAFETY:-on}"
  local backup_root="${RM_SHOTGUN_BACKUP_DIR:-$HOME/.rm-shotgun-backups}"
  local raw_root="$backup_root/raw"
  local has_recursive=0
  local has_force=0
  local skip_backup=0
  local timestamp
  local cleaned_args=()

  timestamp="$(date +%Y%m%d-%H%M%S)"

  for arg in "$@"; do
    case "$arg" in
      --no-shotgun-backup)
        skip_backup=1
        ;;
      --)
        cleaned_args+=("$arg")
        ;;
      -*)
        [[ "$arg" == *r* || "$arg" == *R* ]] && has_recursive=1
        [[ "$arg" == *f* ]] && has_force=1
        cleaned_args+=("$arg")
        ;;
      *)
        cleaned_args+=("$arg")
        ;;
    esac
  done

  if [[ "$safety" == "off" || "$skip_backup" -eq 1 ]]; then
    echo "[rm-shotgun] safety off, no backup"
    command rm "${cleaned_args[@]}"
    return $?
  fi

  if [[ "$has_recursive" -eq 1 && "$has_force" -eq 1 ]]; then
    mkdir -p "$raw_root/$timestamp"

    for target in "${cleaned_args[@]}"; do
      case "$target" in
        -*|--)
          continue
          ;;
      esac

      if [[ -e "$target" || -L "$target" ]]; then
        echo "[rm-shotgun backup] $target -> $raw_root/$timestamp/"
        cp -a -- "$target" "$raw_root/$timestamp/"
      fi
    done
  fi

  command rm "${cleaned_args[@]}"
}
