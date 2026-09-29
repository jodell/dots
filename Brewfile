# Packages these dotfiles actually reference. Install with:
#
#   brew bundle --file=Brewfile        (or: make deps)
#
# Each line cites what in the repo needs it, so this list can be pruned when
# the config that justifies it goes away.

# --- shell core -------------------------------------------------------------
brew "bash"                  # macOS ships bash 3.2 (2007); bin/linkify targets modern bash
brew "bash-completion@2"     # etc/shell/interactive.sh sources $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh
brew "zsh"                   # etc/zshrc
brew "coreutils"             # etc/dir_colors is a GNU dircolors file -- see note below
brew "tree"                  # etc/shell/aliases.sh: have tree && alias tree='tree -C'
brew "htop"
brew "tmux"                  # etc/tmux.conf

# --- editor -----------------------------------------------------------------
brew "vim"                   # etc/vimrc
brew "universal-ctags"       # etc/ctags config file; required by vendor/tagbar and vendor/vim-go
brew "ack"                   # vendor/ack.vim (g:ackprg defaults to ack)
brew "the_silver_searcher"   # faster ack.vim backend: let g:ackprg = 'ag --vimgrep'
brew "markdown"              # etc/vimrc <leader>m renders the buffer to /tmp/preview.html

# --- version control --------------------------------------------------------
brew "git"                   # etc/gitconfig
brew "gnupg"                 # etc/gitconfig [gpg] program = gpg; commit signing
brew "pinentry-mac"          # lets gpg prompt for the signing passphrase on macOS
brew "gh"                    # etc/gitconfig url."git@github.com:".pushInsteadOf workflow
cask "1password-cli"         # `op`: read secrets from the vault. NOT used for ssh --
                             # keys come from the login keychain (macOS) or a
                             # CLI-started agent (Linux), see etc/shell/ssh-agent.sh

# --- languages --------------------------------------------------------------
brew "rbenv"                 # etc/shell/env.sh: rbenv init
brew "ruby-build"            # needed to install the 3.1.2 pinned in .ruby-version
brew "go"                    # etc/shell/env.sh GOPATH/GOROOT; vendor/vim-go
brew "openjdk"               # etc/shell/env.sh openjdk PATH + JAVA_HOME; leiningen needs a JRE
brew "leiningen"             # etc/lein/profiles.clj; vendor/{vim-fireplace,vim-salve,paredit,vim-clojure}
brew "node"                  # vendor/typescript-vim, vendor/vim-json

# --- databases --------------------------------------------------------------
brew "libpq"                 # etc/psqlrc needs psql (libpq is the client alone; use
                             # `brew install postgresql@16` instead if you want a server)
brew "sqlite"                # etc/sqliterc

# --- misc -------------------------------------------------------------------
brew "rsync"                 # macOS ships rsync 2.6.9; the ~/.ssh/rc bug was found via rsync
brew "ansiweather"           # ~/.dots.local/aliases.sh: alias weather

cask "gcloud-cli"            # etc/shell/env.sh sources $HOMEBREW_PREFIX/share/google-cloud-sdk

# --- wanted on every machine ------------------------------------------------
# Not referenced by anything in this repo -- here so a fresh box gets them.
brew "imagemagick"           # convert/magick/mogrify/identify

# NOTE on coreutils: brew installs GNU tools g-prefixed, so `dircolors` stays
# absent and etc/dir_colors goes unused unless you put the gnubin dir on PATH:
#   path_prepend "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
# Adding that also makes ls/date/sed behave like they do on Mint and the Pi,
# which is either the point or a surprise, depending on your taste.
