#!/usr/bin/env ruby
pwd = File.expand_path(File.dirname(__FILE__))

puts "Linking dotfiles..."

dotfiles_dir = "#{pwd}/../etc"

Dir["#{dotfiles_dir}/*"].each do |f|
  next if File.directory?(f)
  `rm ~/.#{File.basename(f)}; ln -s #{File.expand_path(f)} ~/.#{File.basename(f)}`
end

# SSH config
Dir["#{dotfiles_dir}/ssh/*"].each do |f|
  puts "Symlinking: ln -sf #{File.expand_path(f)} ~/.ssh/#{File.basename(f)}"
  `rm ~/.ssh/#{File.basename(f)}; ln -s #{File.expand_path(f)} ~/.ssh/#{File.basename(f)}`
end

# Bash Completion
puts "Symlinking: ln -sf #{File.expand_path(dotfiles_dir + '/bash')} ~/.bash"
`rm ~/.bash; ln -s #{File.expand_path(dotfiles_dir + '/bash')} ~/.bash`

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
vim-pathogen
vim-conque
mustache.vim
webapi-vim
).each do |plugin|
  puts "Symlinking: ln -sf #{pwd}/../vendor/#{plugin} ~/.vim/bundle/#{plugin}"
  `rm ~/.vim/bundle/#{plugin}; ln -s #{pwd}/../vendor/#{plugin} ~/.vim/bundle/#{plugin}`
end

# Inkpot
`rm ~/.vim/colors/inkpot.vim; ln -s #{pwd}/../vendor/inkpot/colors/inkpot.vim ~/.vim/colors/inkpot.vim`
