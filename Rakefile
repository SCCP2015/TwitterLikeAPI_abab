require 'rspec/core/rake_task'
require 'dm-core'
require 'dm-migrations'
# Model Classes
require_relative 'src/word'

RSpec::Core::RakeTask.new(:spec)

task 'db:migrate' do
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, 'postgres://vagrant:vagrant@localhost/myapp')
  DataMapper.auto_upgrade!
  self
end

task default: :spec
