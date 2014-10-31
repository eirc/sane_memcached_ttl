require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.name = 'spec'
  t.libs << 'spec'
  t.test_files = FileList['spec/**/*_spec.rb'].exclude(/^spec\/integration\//)
  t.verbose = true
end

Rake::TestTask.new do |t|
  t.name = 'integration'
  t.libs << 'spec'
  t.test_files = FileList['spec/integration**/*_spec.rb']
  t.verbose = true
end

desc 'Run tests'
task :default => [:spec, :integration]
