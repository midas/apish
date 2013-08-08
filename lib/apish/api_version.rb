require 'active_support/core_ext/object/try'

class Apish::ApiVersion

  attr_reader :accepts

  def initialize( accepts )
    @accepts = accepts
  end

  def to_s
    parse
  end

  def to_i
    parse.try( :to_i ) || 0
  end

  def max
    1
  end

  def exists?
   to_i <= max
  end

  def most_recent?
    to_i == max
  end

  def self.version_regex
    /application\/vnd.#{Apish.configuration.mime_types_base}-v(\d+)\+\w*/
  end

private

  def parse
    matches = accepts.match( self.class.version_regex )
    matches.try :[], 1
  end

end
