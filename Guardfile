# frozen_string_literal: true

# to clear the screen before every task
clearing :on

# This group allows to skip running RuboCop when RSpec failed.
group :red_green_refactor, halt_on_fail: true do
  guard :rubocop, notification: true, cli: ['lib', 'spec', 'Rakefile', '--format', 'simple', '--format', 'html', '--out', 'rubocop-report.html'] do
    watch(%r{^lib/(.+)\.rb$})
    watch(%r{^spec/unit/.+_spec\.rb$})
    watch(%r{^spec/integration/.+_spec\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { %w[lib spec Rakefile] }
  end

  guard :rspec, cmd: 'bundle exec rspec', spec_paths: ['spec/unit'] do
    require 'guard/rspec/dsl'
    dsl = Guard::RSpec::Dsl.new(self)

    watch(%r{^spec/unit/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/unit/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { 'spec/unit' }
  end
end
