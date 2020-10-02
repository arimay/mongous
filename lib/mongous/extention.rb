
module Mongous
  module Extention
    def client
      if self.class_variable_defined?( :@@client )
        self.class_variable_get( :@@client )
      else
        _client  =  Mongous.client
        self.class_variable_set( :@@client, _client )
      end
    end

    def set_client( _client )
      m  =  /(.*?):(\d+)/.match( caller()[0] )
      call_from  =  [ m[1], m[2] ].join(":")
      if  !_client.is_a?( Mongo::Client )
        raise  Mongous::Error, "type invalid. :  #{ _client }"
      end
      self.class_variable_set( :@@client, _client )
    end

    def collection_name
      if self.class_variable_defined?( :@@collection_name )
        self.class_variable_get( :@@collection_name )
      else
        _client_name  =  self.name
        self.class_variable_set( :@@collection_name, _client_name )
      end
    end

    def set_collection_name( _collection_name )
      self.class_variable_set( :@@collection_name, _collection_name )
      if self.class_variable_defined?( :@@collection )
        self.remove_class_variable( :@@collection )
      end
    end

    def collection
      if self.class_variable_defined?( :@@collection )
        if  _collection  =  self.class_variable_get( :@@collection )
          return  _collection
        end
      end

      _collection_name  =  collection_name
      _client  =  client

      if  _client.database.collection_names.include?( _collection_name )
        _collection  =  _client[ _collection_name ]
      else
        _collection  =  _client[ _collection_name ]
        _collection.create
      end

      indexes.each do |keys, opts|
        _collection.indexes.create_one( keys, opts )    rescue  nil
      end

      self.class_variable_set( :@@collection, _collection )
    end

    def fields
      if self.class_variable_defined?( :@@fields )
        self.class_variable_get( :@@fields )
      else
        self.class_variable_set( :@@fields, {} )
      end
    end

    def symbols
      if self.class_variable_defined?( :@@symbols )
        self.class_variable_get( :@@symbols )
      else
        self.class_variable_set( :@@symbols, {} )
      end
    end

    def blocks
      if self.class_variable_defined?( :@@blocks )
        self.class_variable_get( :@@blocks )
      else
        self.class_variable_set( :@@blocks, {} )
      end
    end

    def indexes
      if self.class_variable_defined?( :@@indexes )
        self.class_variable_get( :@@indexes )
      else
        self.class_variable_set( :@@indexes, [] )
      end
    end

    def create( **doc )
      self.new( **doc ).save
    end

    def find( conditios = {}, options = {} )
      self.collection.find( conditios, options )
    end

    def field( label, *args, **opts, &block )
      m  =  /(.*?):(\d+)/.match( caller()[0] )
      call_from  =  [ m[1], m[2] ].join(":")

      args.each do |arg|
        if klass  =  arg.class 
          if ![Class, Range, Array, Proc, Symbol].include?(klass)
            raise  Mongous::Error, "field error. :  #{arg} on #{ label } at #{ call_from }"
          end
        end
      end

      opts.each do |key, value|
        case  key
        when  :default
          case  value
          when  Proc, String, Numeric
          else
            raise  Mongous::Error, "field error. : #{key} on #{ label } at #{ call_from }"
          end
        end
      end

      opts[:_args]  =  args
      opts[:_block]  =  block
      fields[label.to_s]  =  opts
    end

    def verify( *syms, &block )
      if !syms.empty?
        syms.each do |sym|
          symbols[sym]  =  true
        end
      elsif block
        m  =  /(.*?):(\d+)/.match( caller()[0] )
        call_from  =  [ m[1], m[2] ].join(":")
        blocks[call_from]  =  block
      end
    end

    def index( *syms, **opts )
      opts[:background]  =  true    unless opts.has_key?(:background)
      keys  =  {}
      syms.each do |sym|
        keys[sym]  =  1
      end
      indexes.push  <<  [keys, opts]
    end
  end
end
