# Portable aliases. Anything OS-specific belongs in aliases.darwin /
# aliases.linux; anything machine-specific (hosts, keys, work paths) belongs in
# ~/.dots.local/aliases.sh, which is deliberately outside this repo.

# ls colors: GNU wants --color, BSD/macOS wants CLICOLOR. Probe the binary
# rather than sniffing /etc/issue -- containers often have neither file.
if ls --color=auto /dev/null >/dev/null 2>&1; then
  alias ls='ls --color=auto'
  have dircolors && [ -r "$HOME/.dir_colors" ] && eval "$(dircolors -b "$HOME/.dir_colors")"
else
  export CLICOLOR=1
fi

alias ll='ls -l'
alias la='ls -a'
alias l='ls -CF'
alias h='history'
alias grep='grep --color=auto'
alias rgrep='grep -r --color=auto'
alias less='less -XLR'
alias disk='du -d 1 -h'
have tree && alias tree='tree -C'

alias dots='cd ~/git/dots'

# git
alias gs='git s'
alias gf='git fetch'
alias gd='git d'
alias ga='git add'
alias gco='git co'
alias gb='git b'
alias gdh='git diff HEAD'
alias gsh='git show HEAD'
alias gm='git merge --no-ff'
alias grb='git rebase'
alias reup='git fetch && git pull origin "$(git_current_branch)"'
alias gpthis='git push origin HEAD:$(git_current_branch)'
alias gup='git fetch origin && git rebase "origin/$(git_current_branch)"'

git_current_branch() { git symbolic-ref --short HEAD 2>/dev/null; }

# ruby
alias r='rake'
alias rtest='ruby -I"lib:test"'
alias bi='bundle install'
alias brake='bundle exec rake'
alias bx='bundle exec'

# reload
alias realias='. ~/.shell/aliases.sh'

alias crontab='VIM_CRONTAB=true crontab'

mwiki() { dig +short txt "$*".wp.dg.cx; }

dots_source "$HOME/.shell/aliases.$DOTS_OS"
dots_source "$HOME/.dots.local/aliases.sh"
dots_source "$HOME/.bash_aliases.local"   # legacy location
return 0
