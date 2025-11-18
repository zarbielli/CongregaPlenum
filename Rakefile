# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rdoc/task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = 'CongregaPlenum Documentation'
  rdoc.main = 'README.md'
  rdoc.options << '--markup' << 'markdown'
  rdoc.rdoc_files.include('README.md', 'lib/**/*.rb')
end

task default: %i[spec rubocop]
