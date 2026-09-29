# Keep one ssh-agent per login and reuse it across shells, tmux panes and
# reconnects -- for Linux desktops, servers and the Pi.
#
# macOS needs none of this: launchd runs an agent for the session, and
# `UseKeychain yes` + `AddKeysToAgent yes` in ~/.ssh/config load the key from
# the login keychain on first use and remember the passphrase across reboots.
#
# Nothing here adds keys. ssh_config's `AddKeysToAgent yes` does that on first
# use, so an unused key is never loaded and never prompts.

[ "$DOTS_OS" = darwin ] && return 0
dots_interactive || return 0
have ssh-agent || return 0

_dots_agent_env="$HOME/.ssh/agent.env"

# ssh-add exit codes: 0 = agent has keys, 1 = agent is up but empty,
# 2 = cannot reach an agent. Only 2 means we need to do something.
_dots_agent_alive() {
  [ -n "${SSH_AUTH_SOCK:-}" ] && [ -S "$SSH_AUTH_SOCK" ] || return 1
  ssh-add -l >/dev/null 2>&1
  [ $? -ne 2 ]
}

# An inherited agent -- a forwarded one from `ssh -A`, or the desktop session's
# gnome-keyring -- always wins; never shadow it with a second agent.
if ! _dots_agent_alive && [ -r "$_dots_agent_env" ]; then
  # `ssh-agent -s` output ends in `echo Agent pid NNNN;`, so this MUST be
  # sourced with stdout redirected or every login prints a line -- which is the
  # exact bug that corrupted rsync from ~/.ssh/rc.
  . "$_dots_agent_env" >/dev/null 2>&1
fi

if ! _dots_agent_alive; then
  # If ssh-agent cannot start, leave no stale env file behind for the next
  # shell to source; just carry on agentless and silent.
  if (umask 077; ssh-agent -s >"$_dots_agent_env" 2>/dev/null) &&
     [ -s "$_dots_agent_env" ]; then
    . "$_dots_agent_env" >/dev/null 2>&1
  else
    rm -f "$_dots_agent_env"
  fi
fi

unset _dots_agent_env
unset -f _dots_agent_alive 2>/dev/null
return 0
