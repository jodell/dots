# Interactive-only setup: history, completion, prompt, tty-bound state.
#
# Everything here is skipped for non-interactive shells. That matters: `tty`
# and completion loaders fail noisily when there is no terminal, and that noise
# lands in the middle of rsync/scp/git streams.

dots_interactive || return 0

# GPG needs to know which terminal to prompt on. Only meaningful with a tty.
GPG_TTY=$(tty 2>/dev/null) && export GPG_TTY

# --- History ----------------------------------------------------------------
HISTSIZE=10000
case "$DOTS_SHELL" in
  bash)
    HISTCONTROL=erasedups:ignoredups
    HISTIGNORE='&:ls:[bf]g:exit'
    HISTFILESIZE=10000
    PROMPT_COMMAND='history -a'
    export HISTCONTROL HISTIGNORE HISTSIZE HISTFILESIZE PROMPT_COMMAND
    shopt -s histappend cmdhist checkwinsize
    ;;
  zsh)
    SAVEHIST=10000
    HISTFILE="$HOME/.zsh_history"
    setopt APPEND_HISTORY INC_APPEND_HISTORY HIST_IGNORE_DUPS \
           HIST_IGNORE_SPACE HIST_REDUCE_BLANKS SHARE_HISTORY
    ;;
esac

# --- Completion -------------------------------------------------------------
if [ "$DOTS_SHELL" = bash ]; then
  # bash-completion: distro path first, then brew's.
  dots_source /usr/share/bash-completion/bash_completion ||
    dots_source /etc/bash_completion
  [ -n "${HOMEBREW_PREFIX:-}" ] &&
    dots_source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

  # Project/rake completions shipped in this repo.
  [ -x "$HOME/.bash/completion/rake_completion" ] &&
    complete -C "$HOME/.bash/completion/rake_completion" -o default rake
  [ -x "$HOME/.bash/completion/project_completion" ] &&
    complete -C "$HOME/.bash/completion/project_completion" -o default c

  # git prompt, if the distro ships it.
  for _dots_gp in \
    /usr/share/git-core/contrib/completion/git-prompt.sh \
    /usr/lib/git-core/git-sh-prompt \
    "${HOMEBREW_PREFIX:-/nonexistent}/etc/bash_completion.d/git-prompt.sh"
  do
    [ -r "$_dots_gp" ] || continue
    . "$_dots_gp"
    PS1='[\h:\w$(__git_ps1)] \u\$ '
    break
  done
  unset _dots_gp
  : "${PS1:=[\h:\w] \u\$ }"
fi

[ -n "${DOTS_GCLOUD_SDK:-}" ] &&
  dots_source "$DOTS_GCLOUD_SDK/completion.$DOTS_SHELL.inc"

dots_source "$HOME/.shell/ssh-agent.sh"
dots_source "$HOME/.shell/aliases.sh"
dots_source "$HOME/.dots.local/interactive.sh"
return 0
