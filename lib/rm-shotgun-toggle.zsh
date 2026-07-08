# rm-shotgun-toggle.zsh
# Toggle RM_SHOTGUN_SAFETY with zsh keybinding.

rm_shotgun_toggle() {
  if [[ "${RM_SHOTGUN_SAFETY:-on}" == "off" ]]; then
    export RM_SHOTGUN_SAFETY=on
    zle -M "rm-shotgun safety: ON"
  else
    export RM_SHOTGUN_SAFETY=off
    zle -M "rm-shotgun safety: OFF"
  fi

  zle reset-prompt
}

zle -N rm_shotgun_toggle

# One-key toggle: Ctrl+G.
bindkey '^G' rm_shotgun_toggle
