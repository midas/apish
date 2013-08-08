module Apish::Controller::CheckFormat

  extend ActiveSupport::Concern

  included do
    before_filter :check_format
  end

protected

  def check_format
    unless self.class.supported_formats.key?( request.format )
      respond_with_unsupported_format
    end
  end

  def respond_with_unsupported_format
    render :status => :not_found,
           :text   => unsupported_text
  end

  def unsupported_text
    return "You must provide a format for #{request.path.split( '.' ).first.inspect}" if params[:format].blank?
    "Format #{params[:format].inspect} not supported for #{request.path.split( '.' ).first.inspect}"
  end

end
