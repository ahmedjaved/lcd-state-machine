require 'tasks/state_machine'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'fileutils'
require 'coveralls/rake/task'
require 'rake/clean'

CLEAN.include(FileList['coverage'])

task default: %w(clean rubocop spec:unit)

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

task draw_state_machine_diagram: [:setup_options_for_state_machine_diagram, :'state_machine:draw'] do
  FileUtils.move "#{ENV['CLASS']}_state.png", 'state_machine_diagram.png'
end

task :setup_options_for_state_machine_diagram do
  ENV['FILE'] = './lib/lcd_state_machine.rb'
  ENV['CLASS'] = 'RaspberryPiControlPanel::LcdStateMachine'
end

task :setup_git_submodule do
  sh <<-RUBY
  git submodule init
  git submodule update
  RUBY
end

Coveralls::RakeTask.new
task ci: [:default, :'coveralls:push']
