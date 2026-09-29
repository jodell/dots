# Dotfiles

Portable across macOS and Debian-family Linux (Mint, Ubuntu, Debian, Raspberry
Pi OS), on desktops and on servers you only ever ssh into.

## Install

```sh
git clone https://github.com/jodell/dots ~/git/dots
cd ~/git/dots
make                # submodules + symlinks
make minimal        # servers/Pi: shell, git, ssh -- no vim plugin tree
make deps           # optional: install git/vim/tmux/tree/htop via brew|apt|dnf|pacman
```

`bin/linkify` does the symlinking and is safe to re-run. `bin/linkify --dry-run`
shows what it would change; real files are moved aside to `*.bak-<timestamp>`
rather than clobbered.

## Layout

```
etc/shell/      shared POSIX shell core, sourced by BOTH bash and zsh
  os.sh           platform detection + have() / path_prepend() helpers
  brew.sh         locate Homebrew/Linuxbrew wherever it lives
  env.sh          PATH and environment (non-interactive safe)
  interactive.sh  history, completion, prompt -- interactive only
  aliases.sh      portable aliases
  aliases.darwin  macOS-only
  aliases.linux   Linux-only
etc/            everything else -> ~/.<name>  (vimrc, gitconfig, tmux.conf, ...)
etc/ssh/        -> ~/.ssh/
bin/            -> ~/bin/
vendor/         vim plugins as submodules -> ~/.vim/pack/dots/start/
```

## Machine-local overrides

Nothing machine-specific belongs in this repo — it gets cloned onto work
boxes. These files are read if present and ignored if not:

| File | Holds |
| --- | --- |
| `~/.gitconfig.local` | `user.email`, `signingkey`, `commit.gpgsign`, work `includeIf` |
| `~/.ssh/config.local` | hosts, jump boxes, LAN addresses, per-host `ForwardAgent yes` |
| `~/.dots.local/aliases.sh` | personal aliases |
| `~/.dots.local/env.sh` | personal env/PATH |
| `~/.zshrc.local`, `~/.bashrc.local` | per-shell extras |
| `~/.vimrc.local`, `~/.tmux.conf.local` | per-app extras |

## Two rules worth keeping

**Shell startup must never write to stdout.** `~/.bashrc` is sourced for
`ssh host cmd`, so anything printed there lands in the middle of the stream and
breaks rsync, scp and git with *"protocol version mismatch — is your shell
clean?"*. This repo has shipped that bug twice. `make test` asserts it now.

**Never put a missing or empty directory on `PATH`.** `PATH="$X/bin:$PATH"`
with `$X` empty leaves an empty element, which POSIX resolves to the current
directory — every file in whatever repo you just `cd`'d into becomes
executable by name. Use `path_prepend`, which checks and dedupes.

## Commit signing

Commits are signed with an **SSH** key, not GPG (`gpg.format = ssh`), using the
same key you already authenticate with. `~/.gitconfig.local` names the public
half; the private half comes from the agent.

```sh
make allowed-signers   # rebuild ~/.ssh/allowed_signers so local verification works
git log --show-signature -1
```

Register the **public** key on GitHub a second time, as a *Signing* key — an
Authentication key does not verify commits.

Commits signed with the old GPG key (7DC14831, pre-2026-09-29) still need that
public key to verify; the switch to SSH is not retroactive.

## ssh keys and the agent

| Platform | How the key is held |
| --- | --- |
| macOS | login keychain. `UseKeychain yes` + `AddKeysToAgent yes` in `etc/ssh/config`; launchd runs the agent. The passphrase is entered once, ever. |
| Linux / servers / Pi | `etc/shell/ssh-agent.sh` starts one agent per login and reuses it across shells, tmux panes and reconnects via `~/.ssh/agent.env`. |

Neither path adds keys up front — `AddKeysToAgent yes` loads a key on first
use, so a key you never use is never unlocked. An inherited agent always wins:
a forwarded agent from `ssh -A`, or a desktop session's gnome-keyring, is used
as-is and never shadowed by a second one.

## Testing

```sh
make check        # syntax-check every shell file, gitconfig, ssh config, tmux.conf
make test         # check + bin/smoke-test against this machine
make test-docker  # smoke test inside debian:stable-slim and ubuntu:latest
```

`bin/smoke-test` asserts that bash/zsh/sh produce empty stdout and exit 0 for
interactive, login and non-interactive startup, that `PATH` has no empty
elements, and that vim, git and ssh configs parse without errors.
