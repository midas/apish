#require 'apish/railtie' if defined?( Rails )

module Apish

  autoload :ApiVersion,     "apish/api_version"
  autoload :Configuration,  "apish/configuration"
  autoload :Controller,     "apish/controller"
  autoload :Error,          "apish/error"
  autoload :FormatResolver, "apish/format_resolver"
  autoload :Responder,      "apish/responder"
  autoload :VERSION,        "apish/version"

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  def self.register_custom_mime_types
    dir = File.join( Rails.root, 'app', 'controllers', 'api' )
    Dir.glob( "#{dir}/v*" ) do |d|
      version = d[/(v\d+)$/, 1]
      types = %w( json xml ).collect do |wire_format|
        "api_#{version}_#{wire_format}"
      end
      types.each do |type|
        mime_type = ["application/vnd.#{Apish.configuration.mime_types_base}",
                     type.split( '_' )[1..2].join( '+' )].join( '-' )
        next if Mime.const_defined?( type.upcase )
        Mime::Type.register mime_type, type.to_sym
      end
    end
  end

end
