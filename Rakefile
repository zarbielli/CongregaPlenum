# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

require 'yard'
require 'yard/rake/yardoc_task'

YARD::Rake::YardocTask.new(:yard) do |yard|
  yard.files = ['README.md', 'lib/**/*.rb']
  yard.options = ['--markup', 'markdown', '--main', 'README.md']
end

task default: %i[spec rubocop]
