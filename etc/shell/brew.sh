# Locate Homebrew / Linuxbrew and load its environment. Idempotent: safe to
# source from both ~/.zprofile (early, so FPATH can see it) and env.sh.
#
# Do NOT hardcode a prefix. Apple Silicon, Intel macOS and Linuxbrew all differ,
# and plenty of machines have no brew at all.

[ "${DOTS_BREW_LOADED:-0}" = 1 ] && return 0

for _dots_brew in \
  /opt/homebrew/bin/brew \
  /usr/local/bin/brew \
  /home/linuxbrew/.linuxbrew/bin/brew \
  "$HOME/.linuxbrew/bin/brew"
do
  [ -x "$_dots_brew" ] || continue
  eval "$("$_dots_brew" shellenv)"
  DOTS_BREW_LOADED=1
  break
done
unset _dots_brew

: "${DOTS_BREW_LOADED:=0}"
return 0
