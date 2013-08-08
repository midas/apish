module Apish::Responder::Version

  def respond( *args )
    controller.headers['X-Api-Version'] = controller.class.name.match( /^Api::V(\d*)::.*$/ ).try( :[], 1 )

    super( *args )
  end

protected

  def accept
    request.headers['Accept']
  end

end
