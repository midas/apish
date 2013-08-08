require 'active_support/concern'

module Apish::Controller

  autoload :CheckFormat, 'apish/controller/check_format'
  autoload :Rescue,      'apish/controller/rescue'

  extend ActiveSupport::Concern

  module ClassMethods

    # Adds common API controller functionality.
    #
    def acts_as_api_controller
      base  = self.name.split( '::' )[0..1].join( '_' ).downcase
      json  = "#{base}_json"
      xml   = "#{base}_xml"
      types = [json, xml]

      formats = { Mime::const_get( json.upcase ) => :json,
                  Mime::const_get( xml.upcase )  => :xml }

      class_eval do
        def self.supported_formats
          Hash[*(self.mimes_for_respond_to.keys.map { |f| [Mime::Type.lookup_by_extension(f), f.to_s[/^api_v\d+_(.+)$/, 1]] }.flatten)]
        end
      end

      # Set up custom mime types that this controller will respond to
      respond_to( *formats.keys.map( &:to_sym ) )

      # Define renderers for each mime type
      formats.each do |mime_type, format|
        if Apish.configuration.representation_framework == :rabl
          ActionController.add_renderer mime_type.to_sym do |object, options|
            templates = options[:prefixes].map { |path| File.join( path, options[:template] ) }.select { |path| File.exists?( File.join( Rails.root, 'app', 'views', "#{path}.rabl" )) }
            # Do not try to render if no templates were found
            unless templates.empty?
              self.content_type ||= mime_type
              self.response_body = Rabl::Renderer.send( format, object, templates.first, :view_path => 'app/views', :scope => self )
            end
          end
        end
      end

      # Define #to_* methods for each custom mime type (in order to get free
      # format.custom_mime_type { render :custom_mime_type => @object } functionality)
      types.each do |type|
        method_name = "to_#{type}"

        unless ActionController::Responder.method_defined?( method_name )
          ActionController::Responder.class_eval do
            define_method method_name do
              # if the default_response Proc is from the current controller, then it is an override
              #controller_provides_response = @default_response.binding.eval( "self.class" ) == controller.class
              controller_provides_response = @default_response.file_colon_line.split( ':' ).first.gsub( /app\/controllers\/|.rb/, '' ).classify == controller.class.name
              if controller_provides_response
                # allow overridden responses in respond_with blocks
                @default_response.call( options )
              else
                collection_name = controller.class.name.gsub( /Controller/, '' ).gsub( /Api::V\d+::/, '' ).tableize
                object_name = collection_name.singularize
                object = controller.instance_variable_get( "@#{collection_name}" ) || controller.instance_variable_get( "@#{object_name}" )
                controller.render type.to_sym => object
              end
            end
          end
        end
      end
    end

  end

end
