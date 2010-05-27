#!/usr/bin/env ruby

dirs = %w(
  ~/.vim/backup
  ~/.vim/tmp
  ~/.vim/colors
)

dirs.each { |dir| `mkdir -p #{dir}` }

Dir['.*'].each do |f| 
  next if ['.', '..', '.git'].include?(f) 
  # Don't deal with overwriting existing files for now 
  next if File.exists?(File.expand_path("~/#{File.basename(f)}"))
  `ln -s #{File.expand_path(f)} ~/#{File.basename(f)}`
end
  
