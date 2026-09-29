# Environment and PATH. Sourced by interactive AND non-interactive shells, so
# it must stay silent and must not assume any tool is installed.

dots_source "$HOME/.shell/brew.sh"

# --- Editor / pager ---------------------------------------------------------
# Resolved by name, never by absolute path: vim lives in /usr/bin on Debian,
# in the brew prefix on macOS, and may be missing entirely on a minimal box.
for _dots_ed in vim vi nano; do
  if have "$_dots_ed"; then
    EDITOR=$_dots_ed
    break
  fi
done
unset _dots_ed
if [ -n "${EDITOR:-}" ]; then
  VISUAL=$EDITOR
  export EDITOR VISUAL
fi

if have less; then
  PAGER=less
  # -R: pass through color escapes. -X/-L set in the interactive alias.
  LESS='-R'
  export LESS
else
  PAGER=more
fi
export PAGER

: "${LANG:=en_US.UTF-8}"
export LANG

# --- PATH -------------------------------------------------------------------
# Lowest priority first; each path_prepend pushes in front of the last.
path_prepend /usr/local/sbin
path_prepend /usr/local/bin
path_prepend "$HOME/.local/bin"

# Java. macOS has java_home (which fails, loudly, when no JDK is registered --
# hence the 2>/dev/null); Linux boxes use the distro symlink.
if [ -z "${JAVA_HOME:-}" ]; then
  if [ "$DOTS_OS" = darwin ] && [ -x /usr/libexec/java_home ]; then
    _dots_java=$(/usr/libexec/java_home 2>/dev/null) || _dots_java=
  fi
  for _dots_jh in \
    "${_dots_java:-}" \
    "${HOMEBREW_PREFIX:-/nonexistent}/opt/openjdk/libexec/openjdk.jdk/Contents/Home" \
    /usr/lib/jvm/default-java
  do
    [ -n "$_dots_jh" ] && [ -d "$_dots_jh" ] && { export JAVA_HOME="$_dots_jh"; break; }
  done
  unset _dots_java _dots_jh
fi
[ -n "${HOMEBREW_PREFIX:-}" ] && path_prepend "$HOMEBREW_PREFIX/opt/openjdk/bin"

# Go. GOROOT is only exported when `go` is actually installed -- an empty
# GOROOT in a PATH expression leaves an empty element, which POSIX reads as
# the current directory (i.e. anything in the cwd becomes executable).
if have go; then
  export GOPATH="${GOPATH:-$HOME/go}"
  GOROOT=$(go env GOROOT 2>/dev/null) && [ -n "$GOROOT" ] && export GOROOT
  path_append "${GOROOT:-/nonexistent}/bin"
  path_prepend "$GOPATH/bin"
fi

# Ruby
case "$DOTS_SHELL" in
  bash | zsh) have rbenv && eval "$(rbenv init - "$DOTS_SHELL")" ;;
esac
[ -d "$HOME/.rvm/bin" ] && path_append "$HOME/.rvm/bin"

# Google Cloud SDK: find it once, here; completion is loaded in interactive.sh.
for _dots_gc in \
  "${HOMEBREW_PREFIX:-/nonexistent}/share/google-cloud-sdk" \
  "$HOME/google-cloud-sdk" \
  /usr/share/google-cloud-sdk \
  /usr/lib/google-cloud-sdk
do
  [ -d "$_dots_gc" ] || continue
  DOTS_GCLOUD_SDK=$_dots_gc
  dots_source "$_dots_gc/path.$DOTS_SHELL.inc"
  break
done
unset _dots_gc

path_prepend "$HOME/bin"
export PATH

dots_source "$HOME/.dots.local/env.sh"
return 0
