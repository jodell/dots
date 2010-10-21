#!/usr/bin/env ruby

puts "Linking dotfiles..."
dirs = %w(
  ~/.vim/backup
  ~/.vim/tmp
  ~/.vim/colors
)

dirs.each { |dir| `mkdir -p #{dir}` }
pwd = File.expand_path(File.dirname(__FILE__))
dotfiles_dir = "#{pwd}/../etc"

Dir["#{dotfiles_dir}/*"].each do |f| 
  next if ['/.', '/..'].map { |s| dotfiles_dir + s }.include?(f) || File.directory?(f)
  puts "Linking file #{f}"
  # Don't deal with overwriting existing files for now 
  #next if File.exists?(File.expand_path("~/#{File.basename(f)}"))
  `ln -sf #{File.expand_path(f)} ~/.#{File.basename(f)}`
end

pwd = File.dirname(File.expand_path(__FILE__))

# SSH config
`ln -sf #{pwd}/../etc/ssh/ssh.config ~/.ssh/config`

`mkdir -p ~/.vim/doc ~/.vim/syntax ~/.vim/plugin`

################################################################################
# VIM Plugins
#
# TODO: Use pathogen
# Inkpot
`ln -sf #{pwd}/../vendor/inkpot/colors/inkpot.vim ~/.vim/colors/inkpot.vim`

# NERD Tree
`cd #{pwd}/../vendor/nerdtree && rake install`

# Cucumber
`cd #{pwd}/../vendor/cucumber && rake install`

# vim-ruby
`cd #{pwd}/../vendor/vim-ruby && bin/vim-ruby-install.rb -d ~/.vim`

# supertab
`ln -sf #{pwd}/../vendor/supertab/plugin/supertab.vim ~/.vim/plugin`
`ln -sf #{pwd}/../vendor/supertab/doc/supertab.txt ~/.vim/doc`

# git-vim
`ln -sf #{pwd}/../vendor/git-vim/plugin/git.vim ~/.vim/plugin`
`ln -sf #{pwd}/../vendor/git-vim/syntax/git-diff.vim ~/.vim/syntax`
`ln -sf #{pwd}/../vendor/git-vim/syntax/git-log.vim ~/.vim/syntax`
`ln -sf #{pwd}/../vendor/git-vim/syntax/git-status.vim ~/.vim/syntax`

# gist-vim
`ln -sf #{pwd}/../vendor/gist-vim/plugin/gist.vim ~/.vim/plugin`

# cocoa.vim
`cd #{pwd}/../vendor/cocoa.vim && cp -r . ~/.vim`

# snipmate.vim
`cd #{pwd}/../vendor/snipmate.vim && cp -r . ~/.vim`


