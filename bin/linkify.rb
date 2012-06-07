#!/usr/bin/env ruby
pwd = File.expand_path(File.dirname(__FILE__))

puts "Linking dotfiles..."

dotfiles_dir = "#{pwd}/../etc"

# Standard dots
Dir["#{dotfiles_dir}/*"].each do |f|
  next if File.directory?(f)
  `test -f ~/.#{File.basename(f)} && rm ~/.#{File.basename(f)}`
  `ln -s #{File.expand_path(f)} ~/.#{File.basename(f)}`
end

# SSH config
Dir["#{dotfiles_dir}/ssh/*"].each do |f|
  puts "Symlinking: ln -sf #{File.expand_path(f)} ~/.ssh/#{File.basename(f)}"
  `test -f ~/.ssh/#{File.basename(f)} && rm ~/.ssh/#{File.basename(f)}`
  `ln -s #{File.expand_path(f)} ~/.ssh/#{File.basename(f)}`
end

# Bash Completion
puts "Symlinking: ln -sf #{File.expand_path(dotfiles_dir + '/bash')} ~/.bash"
`test -d ~/.bash && rm ~/.bash`
`ln -s #{File.expand_path(dotfiles_dir + '/bash')} ~/.bash`

#################################################################################
# VIe
vim_dirs = %w(autoload backup tmp colors bundle).map { |dir| "~/.vim/#{dir}" } * ' '
`mkdir -p #{vim_dirs}`

# Pathogen setup
`cp #{pwd}/../vendor/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim`

Dir["#{pwd}/../vendor/*"].each do |plugin_dir|
  plugin = File.basename(plugin_dir)
  puts "Symlinking: ln -sf #{plugin_dir} ~/.vim/bundle/#{plugin}"
  `test -d ~/.vim/bundle/#{plugin} && rm ~/.vim/bundle/#{plugin}`
  `ln -s #{plugin_dir} ~/.vim/bundle/#{plugin}`
end
