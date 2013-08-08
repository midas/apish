require 'rails/generators'

module Apish

  class EndpointGenerator < Rails::Generators::Base

    attr_reader :action_name,
                :controller_super_class_name

    desc "Description:\n  Creates the specified API endpoint with all spec files, etc."

    argument :endpoint_name, :type => :string, :required => true
    argument :action_names, :type => :array, :required => false

    class_option :view_engine, :type => :string, :aliases => "-t", :desc => "Template engine for the views. Available options are 'rabl'.", :default => "rabl"
    class_option :view_specs, :type => :boolean, :default => false

    def self.source_root
      File.join File.dirname(__FILE__),
                'templates'
    end

    def install_controller
      @controller_super_class_name = ask( 'What is the class name (without namespace) of the versioned super class for this API endpoints controller (press enter for ApiController)?' )
      @controller_super_class_name = default_controller_super_class_name if @controller_super_class_name.blank?
      template "controller.erb", File.join( 'app', 'controllers', "#{controller_file_name}.rb" )
    end

    def install_controller_spec
      template "controller_spec.erb", File.join( 'spec', 'controllers', "#{controller_spec_file_name}.rb" )
    end

    def install_routing_spec
      template "routing_spec.erb", File.join( 'spec', 'routing', "#{routing_spec_file_name}.rb" )
    end

    def install_request_specs
      return if action_names.blank?

      basename = ask( 'What base name would you like for the request_spec(s) (press enter for authenticated_request)?' )
      basename = default_request_spec_base_name if basename.blank?

      action_names.each do |action_name|
        @action_name = action_name
        template "request_spec.erb", File.join( 'spec', 'requests', "#{request_spec_file_name( action_name, "#{basename}_spec" )}.rb" )
      end
    end

    def install_views
      return if action_names.blank?

      action_names.each do |action_name|
        create_file File.join( 'app', 'views', view_file_name( action_name ))
      end
    end

    def install_view_specs
      return if action_names.blank? || options[:view_specs] == false

      action_names.each do |action_name|
        template "view_spec.erb", File.join( 'spec', 'views', "#{view_spec_file_name( action_name )}.rb" )
      end
    end

  private

    def default_controller_super_class_name
      'ApiController'
    end

    def default_request_spec_base_name
      'authenticated_request'
    end

    def view_file_name( action_name )
      [versioned_endpoint_human_name, "#{action_name}.#{view_file_extension}"].join( '/' )
    end

    def view_spec_file_name( action_name )
      [versioned_endpoint_human_name, "#{action_name}.#{view_file_extension}_spec"].join( '/' )
    end

    def view_file_extension
      options[:view_engine]
    end

    # api/v1/blocks
    def versioned_endpoint_human_name
      endpoint_name.underscore
    end

    # blocks
    def endpoint_human_name
      human_name.split( '/' ).last
    end

    # api/v1/blocks_controller
    def controller_file_name
      [endpoint_name.underscore, '_controller'].join
    end

    # api/v1/blocks_controller_spec
    def controller_spec_file_name
      [controller_file_name, '_spec'].join
    end

    # api/v1/blocks_routing_spec
    def routing_spec_file_name
      [endpoint_name.underscore, '_routing_spec'].join
    end

    # api/v1/blocks/create/something_spec
    def request_spec_file_name( action_name, filename )
      [endpoint_name.underscore, action_name, filename].join( '/' )
    end

    def endpoint_controller_class
      [endpoint_name.camelcase, 'Controller'].join
    end

    def endpoint_namespace
      endpoint_controller_class.split( '::' )[0...-1].join( '::' )
    end

    def endpoint_versioned_base_controller_name( class_name='ApiController' )
      [endpoint_namespace, class_name].join( '::' )
    end

  end

end
