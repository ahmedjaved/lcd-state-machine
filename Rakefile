require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = %w(lib/**/*.rb spec/**/*.rb Rakefile)
  task.formatters = %w(simple html)
  task.fail_on_error = true
  task.options = %w(-o rubocop-report.html)
end

# http://stackoverflow.com/questions/10029250/organizing-rspec-2-tests-into-unit-and-integration-categories-in-rails
namespace :spec do
  desc 'runs unit tests'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/unit/spec_*.rb'
  end

  desc 'runs integration tests'
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = 'spec/integration/spec_*.rb'
  end
end

desc 'runs unit and then integration tests'
task spec: %w(spec:unit spec:integration)

task default: %w(rubocop spec:unit)
