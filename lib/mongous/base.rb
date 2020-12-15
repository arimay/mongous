require "time"
require "erb"
require "yaml"
require "json"
require "mongo"

module Mongous
  class Error < StandardError; end

  module Base
    def connect( hosts_or_uri = nil, file: nil, mode: nil, loglevel: nil, **options )
      case  hosts_or_uri
      when  Array, String
        ;

      when  NilClass
        if file
          mode  ||=  "development"
          text  =  ::File.open( file ).read    rescue  raise( Mongous::Error, "could not load #{ file }" )
          yaml  =  ::ERB.new( text ).result    rescue  raise( Mongous::Error, "could not parse by ERB: #{ file }" )
          hash  =  ::YAML.load( yaml )
          conf  =  hash[mode]["clients"]["default"]

          hosts_or_uri  =  conf["uri"]
          if hosts_or_uri
            conf.delete( "uri" )
            options.merge!( conf )
          else
            hosts_or_uri  =  conf["hosts"]
            conf.delete( "hosts" )
            database  =  conf["database"]
            conf.delete( "database" )
            options.merge!( conf )
            options["database"]  =  database
          end

        else
          hosts_or_uri  =  [ "localhost:27017" ]
          options[:database]  =  "test"    if options[:database].nil? || options[:database].empty?

        end
      end

      ::Mongo::Logger.logger.level  =  loglevel || Logger::ERROR
      ::Mongo::Client.new( hosts_or_uri, options )
    end

    def connect!( hosts_or_uri = nil, **options )
      _client  =  connect( hosts_or_uri, **options )
      self.class_variable_set( :@@client, _client )
    end

    def document!( *names, **opts )
      raise  Mongous::Error, "missing argument."   if names.empty?

      names.each do |name|
        case  name
        when  String
        when  Symbol
          name  =  name.to_s
        else
          raise  Mongous::Error, "type invalid. :  #{ name }"
        end

        raise  Mongous::Error, "missing argument."   unless  /^[A-Z]/.match(name)

        if  Object.const_defined?( name )
          if  Object.const_get( name ).include?( Mongous::Document )
            Object.class_eval{ remove_const( name ) }
          else
            raise  Mongous::Error, "type invalid. :  #{ Object.class_eval(name) }"
          end
        end

        klass  =  Object.class_eval <<-CLASS
          class #{name}
            include Mongous::Document
          end
        CLASS

        if opts[:timestamp]
          klass.class_eval do
            field  :created_at, Time, create: proc{ Time.now }
            field  :updated_at, Time, update: proc{ Time.now }
            index  :created_at
            index  :updated_at
          end
        end
      end
    end
    alias  :attach!  :document!
 
    def client
      if not self.class_variable_defined?( :@@client )
        connect!
      end
      self.class_variable_get( :@@client )
    end

    def client=( _client )
      if not _client.is_a?( ::Mongo::Client )
        raise  Mongous::Error, "type invalid. :  #{ _client }"
      end
      self.class_variable_set( :@@client, _client )
    end

    def loger
      ::Mongo::Logger.logger
    end
  end
end
