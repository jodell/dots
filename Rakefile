
task :default => :go

desc 'Create links'
task :go do
  sh './bin/linkify.rb'
end

namespace 'git' do
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
end
