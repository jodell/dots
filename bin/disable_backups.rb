#!/usr/bin/env ruby
# http://hboon.com/speeding-up-itunes-iphone-synchronization/
# defaults write com.apple.iTunes DeviceBackupsDisabled -bool true
# To re-enable backup:
# defaults write com.apple.iTunes DeviceBackupsDisabled -bool false

case ARGV[0]
when /on|true|1/i
  `defaults write com.apple.iTunes DeviceBackupsDisabled -bool true`
  puts "CAUTION: Disabling iTunes Backups!"
when /off|false|0/i
  `defaults write com.apple.iTunes DeviceBackupsDisabled -bool false`
  puts "INFO: Enabling iTunes Backups!"
else
  puts "Expected true/false, on/off, or 1/0"
end
