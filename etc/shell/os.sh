# Platform detection and small helpers shared by bash and zsh.
#
# POSIX only: no bashisms, no zsh-isms. Sourced from every shell, including
# non-interactive ones, so NOTHING here may write to stdout (see ssh/rc).

# Which shell is reading this.
if [ -n "${ZSH_VERSION:-}" ]; then
  DOTS_SHELL=zsh
elif [ -n "${BASH_VERSION:-}" ]; then
  DOTS_SHELL=bash
else
  DOTS_SHELL=sh
fi

# darwin | linux | unknown
DOTS_OS=$(uname -s 2>/dev/null | tr '[:upper:]' '[:lower:]')
case "$DOTS_OS" in
  darwin | linux) ;;
  *) DOTS_OS=unknown ;;
esac

# darwin | debian | ubuntu | linuxmint | raspbian | unknown
if [ "$DOTS_OS" = darwin ]; then
  DOTS_DISTRO=darwin
elif [ -r /etc/os-release ]; then
  DOTS_DISTRO=$(. /etc/os-release 2>/dev/null && printf '%s' "${ID:-unknown}")
else
  DOTS_DISTRO=unknown
fi

export DOTS_SHELL DOTS_OS DOTS_DISTRO

# have CMD -- is CMD runnable? Quiet: `command -v` alone prints the path, which
# corrupts non-interactive sessions (rsync, scp, git over ssh).
have() { command -v "$1" >/dev/null 2>&1; }

# dots_source FILE -- source FILE if it is readable; return 1 if it is not, so
# callers can chain fallbacks with `||`. Files that end in a dots_source call
# add their own `return 0` so a missing optional file is never an error.
dots_source() {
  [ -r "$1" ] || return 1
  . "$1"
}

# Is this an interactive shell?
dots_interactive() { case "$-" in *i*) return 0 ;; *) return 1 ;; esac; }

# path_prepend DIR -- put DIR at the front of PATH if it exists and is not
# already there. Skipping missing dirs is what keeps a mac-shaped PATH from
# leaking onto Linux; the dedupe keeps nested shells (tmux, screen, su) from
# growing PATH without bound.
path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
  return 0
}

# path_append DIR -- same, at the end.
path_append() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
  return 0
}
