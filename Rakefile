require 'rake'

task :default => [:spec]

desc "Run all module spec tests (Requires rspec-puppet gem)"
task :spec do
  system("rspec spec")
end

desc "Build package"
task :build do
  system("puppet-module build")
end

