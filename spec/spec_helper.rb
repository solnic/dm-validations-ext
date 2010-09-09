require 'dm-core/spec/setup'
require 'dm-core/spec/lib/adapter_helpers'

require 'dm-validations'
require 'dm-migrations'
require 'dm-validations-ext'

SPEC_ROOT = Pathname(__FILE__).dirname

DataMapper::Spec.setup
DataMapper.finalize

Spec::Runner.configure do |config|
  config.extend(DataMapper::Spec::Adapters::Helpers)

  config.before :suite do
    DataMapper.auto_migrate!
  end
end
