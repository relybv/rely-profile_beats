require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

RSpec.configure do |config|
  config.color = false
  config.tty = false
  config.formatter = :documentation # :progress, :html, :documentation
                                    # :json, CustomFormatterClass
end
