#!/usr/bin/env ruby

dirs = %w(
  ~/.vim/backup
  ~/.vim/tmp
  ~/.vim/colors
)

dirs.each { |dir| `mkdir -p #{dir}` }
pwd = File.expand_path(File.dirname(__FILE__))
dotfiles_dir = "#{pwd}/etc/dotsfiles"

Dir["#{dotfiles_dir}/.*"].each do |f| 
  next if ['/.', '/..'].map { |s| dotfiles_dir + s }.include?(f) 
  puts "Linking file #{f}"
  # Don't deal with overwriting existing files for now 
  #next if File.exists?(File.expand_path("~/#{File.basename(f)}"))
  `ln -sf #{File.expand_path(f)} ~/#{File.basename(f)}`
end

pwd = File.dirname(File.expand_path(__FILE__))

# SSH config
`ln -sf #{pwd}/../etc/ssh/ssh.config ~/.ssh/config`

###### VIM PLUGINS ######
# Inkpot
`ln -sf #{pwd}/../vendor/inkpot/colors/inkpot.vim ~/.vim/colors/inkpot.vim`

# NERD Tree
`cd #{pwd}/../vendor/nerdtree && rake install`

# Cucumber
`cd #{pwd}/../vendor/cucumber && rake install`

# vim-ruby
`cd #{pwd}/../vendor/vim-ruby && bin/vim-ruby-install.rb -d ~/.vim`
