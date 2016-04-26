$:.unshift File.expand_path("../../lib", __FILE__)

require "fileutils"
require "pry"

require "bundler-gtags"

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  original_wd  = Dir.pwd
  original_env = ENV.to_hash

  config.after do |example|
    Dir.chdir(original_wd)
    ENV.replace(original_env)
  end
end
