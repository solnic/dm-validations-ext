require 'rubygems'
require 'rake'

begin
  gem 'jeweler', '~> 1.4'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name        = 'dm-validations-ext'
    gem.summary     = 'DataMapper plugin providing better error messages handling.'
    gem.description = gem.summary
    gem.email       = 'piotr.solnica [a] gmail [d] com'
    gem.homepage    = 'http://github.com/solnic/%s' % gem.name
    gem.authors     = [ 'Piotr Solnica' ]
    gem.has_rdoc    = 'yard'

    gem.add_dependency 'dm-validations',  '~> 1.0.2'

    gem.add_development_dependency 'rspec',   '~> 2.0.1'
    gem.add_development_dependency 'jeweler', '~> 1.4'
  end

  Jeweler::GemcutterTasks.new

  FileList['tasks/**/*.rake'].each { |task| import task }
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end
