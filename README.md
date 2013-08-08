# Apish

Apish provides a set of tools to aid in API creation and management.  These tools include but are not limited 
to version maangement, responders and generators.


## Installation

Add this line to your application's Gemfile:

    gem 'apish'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apish


## Usage

### Generators

Generate endpoint with controller, routing, and request specs (default view engine is Rabl):

    rails g apish:endpoint api/v1/things index show create update

Generate endpoint with controller, routing, request and view specs (specifying view engine):

    rails g apish:endpoint api/v1/things index show create update -t rabl --view_specs
