module Apish::Error

  attr_reader :message, :type

  def initialize( message_or_error )
    if message_or_error.is_a?( Exception )
      @message = message_or_error.message
      @type = message_or_error.class.name
    else
      @message = message_or_error
      @type = 'Exception'
    end
  end

  def to_json
    { root => body }.to_json
  end

  def to_xml
    body.to_xml :root => root
  end

protected

  def body
    {
      :message => message,
      :type    => type
    }
  end

  def root
    :error
  end

end
