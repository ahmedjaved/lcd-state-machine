# frozen_string_literal: true

require 'tasks/state_machine'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'fileutils'
require 'rake/clean'
require 'shellwords'

CLEAN.include(FileList['coverage'])

task default: %w[clean rubocop spec:unit]
task unit_display_result_from_top: %w[clean rubocop spec:unit_display_result_from_top]

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = %w[lib/**/*.rb spec/**/*.rb Rakefile]
  task.formatters = %w[simple html]
  task.fail_on_error = true
  task.options = %w[-o rubocop-report.html]
end

# http://stackoverflow.com/questions/10029250/organizing-rspec-2-tests-into-unit-and-integration-categories-in-rails
namespace :spec do
  desc 'runs unit tests'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/unit/*_spec.rb'
  end

  desc 'runs unit tests and shows output using less'
  task :unit_display_result_from_top do
    zsh 'bundle exec rspec --pattern spec/unit/*_spec.rb |& tee run.log; less run.log ; rm run.log'
  end

  desc 'runs integration tests'
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = 'spec/integration/*_spec.rb'
  end

  desc 'runs all tests'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = '--format html --out reports/rspec_results.html'
  end
end

desc 'runs unit and then integration tests'
task spec: %w[spec:spec]

task draw_state_machine_diagram: %i[setup_options_for_state_machine_diagram state_machine:draw] do
  FileUtils.move "#{ENV['CLASS']}_state.png", 'state_machine_diagram.png'
end

task :setup_options_for_state_machine_diagram do
  ENV['FILE'] = './lib/lcd_state_machine.rb'
  ENV['CLASS'] = 'RaspberryPiControlPanel::LcdStateMachine'
end

task :setup_git_submodule do
  sh <<-CMD
  git submodule init
  git submodule update
  CMD
end

def zsh(command)
  escaped_command = Shellwords.escape(command)
  system <<-CMD
    eval "$(rbenv init -)"
    zsh -c #{escaped_command}
  CMD
end
