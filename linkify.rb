#!/usr/bin/env ruby
#require 'fileutils'

dotsfiles = Dir['.*'].reject { |f| ['.', '..', '.git'].include?(f) } 
#puts dotsfiles

# Don't overwrite existing files for now
dotsfiles.each do |f|
  next if File.exists?(File.expand_path("~/#{File.basename(f)}"))
  `ln -s #{File.expand_path(f)} ~/#{File.basename(f)}`
end
