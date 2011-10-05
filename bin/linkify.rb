#!/usr/bin/env ruby
pwd = File.expand_path(File.dirname(__FILE__))

puts "Linking dotfiles..."

dotfiles_dir = "#{pwd}/../etc"

Dir["#{dotfiles_dir}/*"].each do |f| 
  next if File.directory?(f)
  `ln -sf #{File.expand_path(f)} ~/.#{File.basename(f)}`
end

# SSH config
Dir["#{dotfiles_dir}/ssh/*"].each do |f|
  `ln -sf #{File.expand_path(f)} ~/.ssh/#{File.basename(f)}` 
end

# Bash Completion
`ln -sf #{File.expand_path(dotfiles_dir + '/bash')} ~/.bash`

#################################################################################
# VIM
dirs = %w(
autoload
backup
tmp
colors
bundle
).map { |dir| "~/.vim/#{dir}" } * ' '
system "mkdir -p #{dirs}"

# Pathogen setup
`cp #{pwd}/../vendor/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim`

%w(
gist-vim
vim-ruby
nerdtree
snipmate.vim
cucumber
cocoa.vim
supertab
git-vim
vim-json
vim-coffee-script
vim-handlebars
vim-clojure
mustache.vim
).each do |plugin|
  `ln -sf #{pwd}/../vendor/#{plugin} ~/.vim/bundle/#{plugin}`
end

# Inkpot
`ln -sf #{pwd}/../vendor/inkpot/colors/inkpot.vim ~/.vim/colors/inkpot.vim`
