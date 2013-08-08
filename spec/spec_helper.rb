require 'rubygems'
require 'bundler/setup'
require 'apish'

RSpec.configure do |config|

end

def mime_types_base
  'some-app'
end

def configure_apish
  Apish.configure do |config|
    config.mime_types_base = mime_types_base
  end
end
