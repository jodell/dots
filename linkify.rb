#!/usr/bin/env ruby

Dir['.*'].each do |f| 
  next if ['.', '..', '.git'].include?(f) 
  # Don't deal with overwriting existing files for now 
  next if File.exists?(File.expand_path("~/#{File.basename(f)}"))
  `ln -s #{File.expand_path(f)} ~/#{File.basename(f)}`
end
  
