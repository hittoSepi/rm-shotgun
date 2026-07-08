# rm-shotgun

`rm-shotgun` is a small shell safety layer for people who type `rm -rf` with the confidence of a raccoon operating heavy machinery.

It backs up targets before dangerous recursive forced deletes, supports a safety-off switch, can pack old backups, and includes optional zsh keybinding / Powerlevel10k prompt integration.

## What it does

When loaded into an interactive shell, normal commands still work:

```bash
rm file.txt
rm -r folder
```

But this gets backed up before removal:

```bash
rm -rf folder
rm -fr folder
rm -Rf folder
```

Backups go to:

```text
~/.rm-shotgun-backups/raw/YYYYMMDD-HHMMSS/
```

Old raw backups can be packed into:

```text
~/.rm-shotgun-backups/archive/
```

## Install

From this directory:

```bash
chmod +x install.sh
./install.sh
```

Then source your shell config or open a new terminal:

```bash
source ~/.zshrc
```

or:

```bash
source ~/.bashrc
```

The installer copies scripts to:

```text
~/.shell/rm-shotgun/
```

and appends a source block to `.zshrc` or `.bashrc` if possible.

## Manual shell setup

Add this to `~/.zshrc` or `~/.bashrc`:

```bash
# rm-shotgun
[ -f "$HOME/.shell/rm-shotgun/lib/rm-shotgun-guard.sh" ] && source "$HOME/.shell/rm-shotgun/lib/rm-shotgun-guard.sh"
```

For zsh keybinding:

```zsh
[ -f "$HOME/.shell/rm-shotgun/lib/rm-shotgun-toggle.zsh" ] && source "$HOME/.shell/rm-shotgun/lib/rm-shotgun-toggle.zsh"
```

## Safety off

Disable backup for one command:

```bash
RM_SHOTGUN_SAFETY=off rm -rf folder
```

Disable backup for the current shell session:

```bash
export RM_SHOTGUN_SAFETY=off
```

Turn it back on:

```bash
unset RM_SHOTGUN_SAFETY
```

or:

```bash
export RM_SHOTGUN_SAFETY=on
```

You can also skip backup for one command:

```bash
rm --no-shotgun-backup -rf folder
```

## Zsh toggle

The optional zsh toggle binds:

```text
Ctrl+G
```

It toggles `RM_SHOTGUN_SAFETY` between `on` and `off`.

## Powerlevel10k segment

Add this function to `~/.p10k.zsh`:

```zsh
function prompt_rm_shotgun() {
  if [[ "${RM_SHOTGUN_SAFETY:-on}" == "off" ]]; then
    p10k segment -f 196 -t 'RM OFF'
  else
    p10k segment -f 76 -t 'RM SAFE'
  fi
}
```

Then add this element to `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS` or `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS`:

```zsh
rm_shotgun
```

## Packing old backups

Run manually:

```bash
~/.shell/rm-shotgun/bin/rm-shotgun-pack.sh
```

Cron example, hourly at minute 17:

```cron
17 * * * * /home/hitto/.shell/rm-shotgun/bin/rm-shotgun-pack.sh >/dev/null 2>&1
```

The packer:

- packs raw backups older than 60 minutes
- prefers `.tar.zst` if `zstd` exists
- falls back to `.tar.gz`
- deletes archived backups older than 30 days

## Limits

This protects interactive shell usage only.

It does not protect:

```bash
sudo rm -rf folder
/bin/rm -rf folder
command rm -rf folder
scripts that call /bin/rm directly
```

That is intentional. Replacing system `rm` globally is a separate flavor of circus.

## Version

See `VERSION`.
