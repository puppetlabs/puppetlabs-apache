# frozen_string_literal: true

require 'bundler'
require 'puppet_litmus/rake_tasks' if Gem.loaded_specs.key? 'puppet_litmus'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppetlabs-syntax/tasks/puppetlabs-syntax'
require 'puppet-strings/tasks' if Gem.loaded_specs.key? 'puppet-strings'

PuppetLint.configuration.send('disable_relative')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.send('disable_anchor_resource')
PuppetLint.configuration.send('disable_140chars')
# strict_indent is disabled because its expected indentation changed incompatibly
# between puppet-lint-strict_indent-check 3.x (Puppet 7/8 lane, Ruby 3.1) and 5.x
# (Puppet 9 lane, Ruby 3.4+): the two lanes demand opposite indentation for nested
# hashes, so no single manifest layout can satisfy both. See MODULES-11700.
PuppetLint.configuration.send('disable_strict_indent')
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.ignore_paths = [".vendor/**/*.pp", ".bundle/**/*.pp", "pkg/**/*.pp", "spec/**/*.pp", "tests/**/*.pp", "types/**/*.pp", "vendor/**/*.pp"]

