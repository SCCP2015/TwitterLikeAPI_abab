# Usage

## bundle install

      bundle install --path vendor/bundle --without production
   
## launch application
 
      bundle exec rackup -o 0.0.0.0

## check browser or terminal
      
      http://localhost:9292/
      $ curl http://localhost:9292/ 

# Rspec

## add Gemfile
     
      gem 'rake'
      gem 'rspec'

      $ bundle install

## add Rakefile

      $ vim Rakefile

## setup Rspec

      $ bundle exec rspec --init

## edit helperfile

      $ vim spec/spec_helper.rb
     
add text to begging part
      
      #Read test target file
      Dir[File.join(File.dirname(__FILE__), "../src/**/*.rb")].each { |f| require f }

delete text

      ...
      = begin
      ...
      = end
      ...

comment out text
       
      ...
      config.disable_monkey_patching!
      ...
      
# execute Rspec

      $ bundle exec rake

