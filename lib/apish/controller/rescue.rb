module Apish::Controller::Rescue

  extend ActiveSupport::Concern

  included do
    rescue_from Exception, :with => :handle_exception
  end

  module ClassMethods

    def respond_with_detail_exceptions
      @@respond_with_detail_exceptions ||= {}
    end

    def rescue_from_with_details( exception_class, status_code_or_symbol )
      respond_with_detail_exceptions[exception_class] = status_code_or_symbol
    end

  end

protected

  def handle_exception( ex )
    respond_to do |format|
      format.html do
        rescue_action_without_handler( ex )
      end
      format.any do
        log_error( ex )
        erase_results if performed?
        if ex.respond_to?( :handle_response! )
          ex.handle_response!( response )
        end

        if self.class.respond_with_detail_exceptions.key?( ex.class )
          render :status => self.class.respond_with_detail_exceptions[ex.class],
                 :text   => Api::Error.new( ex ).send( to_method_name )
        else
          render :status => :internal_server_error,
                 :text   => Api::Error.new( 'Internal server error' ).send( to_method_name )
        end
      end
    end
  end

  def log_error( ex )
    return unless Rails.logger
    Rails.logger.error "\n#{ex.class} (#{ex.message}):\n #{Rails.backtrace_cleaner.clean(ex.backtrace).join("\n ")}"
  end

  def to_method_name
    return 'to_json' if json_variant?
    return 'to_xml'  if xml_variant?
  end

  def json_variant?
    request.format.to_s.include? 'json'
  end

  def xml_variant?
    request.format.to_s.include? 'xml'
  end

end
