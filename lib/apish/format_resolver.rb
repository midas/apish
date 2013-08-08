require 'active_support/core_ext/object/try'
require 'action_dispatch/http/mime_type'
require 'action_dispatch/http/mime_types'

class Apish::FormatResolver

  attr_reader :accept,
              :current_format

  def initialize( accept, current_format=nil )
    @accept = accept || ''
    @current_format = current_format
  end

  def format
    if current_format == Mime::ALL || current_format.to_s.include?( "application/vnd.#{Apish.configuration.mime_types_base}-v" )
      matches = accept.match( self.class.format_regex )
      mime_type_str = matches.nil? ? current_format : matches[1]
      mime_type = Mime[mime_type_str]
      return mime_type.symbol.to_s unless mime_type.blank?
    elsif current_format.nil?
      matches = accept.match( self.class.format_regex )
      mime_type_str = matches.nil? ? current_format : matches[1]
      mime_type = Mime[mime_type_str]
      return mime_type.symbol.to_s unless mime_type.blank?
    end

    current_format.try( :symbol ).try :to_s
  end

  def self.format_regex
    /application\/vnd.#{Apish.configuration.mime_types_base}-v\d+\+(\w*)/
  end

end
