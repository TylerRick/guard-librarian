require 'rubygems'
require 'guard/librarian'
require 'rspec'

Dir["#{File.expand_path('..', __FILE__)}/support/**/*.rb"].each { |f| require f }

puts "Please do not update/create files while tests are running."

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    ENV["GUARD_ENV"] = 'test'
    ::Guard::Notifier.stub(:notify).and_return(true)
    @fixture_path = Pathname.new(File.expand_path('../fixtures/', __FILE__))
  end

  config.after(:each) do
    ENV["GUARD_ENV"] = nil
  end

end
