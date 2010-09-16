
task :default => [:reup, :go]

desc 'Create links'
task :go do
  sh './bin/linkify.rb'
end

desc 'Sync out submodules'
task :reup => [:'git:sub:init', :'git:sub:update']

namespace 'git' do
  desc 'add relevant submodules'
  task :'sub:add' do
    {
      'vendor/cucumber' => 'git://github.com/jodell/vim-cucumber.git',
      #'vendor/cucumber' => 'git://github.com/tpope/vim-cucumber.git',
      'vendor/nerdtree' => 'git://github.com/scrooloose/nerdtree.git',
      'vendor/inkpot'   => 'git://github.com/ciaranm/inkpot.git'
    }.each do |path, repo|
      next if File.directory?(path)
      sh "git submodule add #{repo} #{path}"
    end
  end

  desc 'init submodules'
  task :'sub:init' do
    sh 'git submodule init'
  end

  desc 'update all submodules'
  task :'sub:update' do
    sh 'git submodule update --recursive'
  end
end
