task :default => :go

desc 'Init submodules and run linkify'
task :go do
  sh 'git submodule init && git submodule update --recursive'
  sh './bin/linkify.rb'
end
