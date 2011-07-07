
task :default => [:reup, :go]

desc 'Create links'
task :go do
  sh './bin/linkify.rb'
end

desc 'Sync out submodules'
task :reup => [:'git:sub:init', :'git:sub:update']

namespace 'git' do
  desc 'init submodules'
  task :'sub:init' do
    sh 'git submodule init'
  end

  desc 'update all submodules'
  task :'sub:update' do
    sh 'git submodule update --recursive'
  end
end
