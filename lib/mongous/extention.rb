
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

    def client=( _client )
      m  =  /(.*?):(\d+)/.match( caller()[0] )
      call_from  =  [ m[1], m[2] ].join(":")
      if  !_client.is_a?( Mongo::Client )
        raise  Mongous::Error, "type invalid. :  #{ _client }"
      end
      self.class_variable_set( :@@client, _client )
    end

    def collection_name
      if self.class_variable_defined?( :@@collection_name )
        value  =  self.class_variable_get( :@@collection_name )
        return  value    if value
      end

      self.class_variable_set( :@@collection_name, self.name )
    end

    def collection_name=( _collection_name )
      self.class_variable_set( :@@collection_name, _collection_name )
      if self.class_variable_defined?( :@@collection )
        self.remove_class_variable( :@@collection )
      end
    end

    def collection( temp_collection_name = nil )
      if  temp_collection_name.nil?
        if self.class_variable_defined?( :@@collection )
          if  _collection  =  self.class_variable_get( :@@collection )
            return  _collection
          end
        end
        _collection_name  =  collection_name
      else
        _collection_name  =  temp_collection_name
      end
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

      self.class_variable_set( :@@collection, _collection )    if temp_collection_name.nil?
      _collection
    end

    def fields
      setup_class_variable( :@@fields, {} )
    end

    def symbols
      setup_class_variable( :@@symbols, {} )
    end

    def blocks
      setup_class_variable( :@@blocks, {} )
    end

    def indexes
      setup_class_variable( :@@indexes, [] )
    end

    def filters
      setup_class_variable( :@@filters, {} )
    end

    def defaults
      setup_class_variable( :@@defaults, {} )
    end

    def setup_class_variable( symbol, default = {}, &block )
      if self.class_variable_defined?( symbol )
        self.class_variable_get( symbol )
      elsif block_given?
        self.class_variable_set( symbol, block.call )
      else
        self.class_variable_set( symbol, default )
      end
    end

    def create( **doc )
      self.new( **doc ).save
    end

    def drop
      self.collection.drop
    end

    def find( conditios = {}, options = {} )
      self.collection.find( conditios, options )
    end

    def field( symbol, *attrs, **items )
      m  =  /(.*?):(\d+)/.match( caller()[0] )
      call_from  =  [ m[1], m[2] ].join(":")

      attrs.each do |attr|
        if klass  =  attr.class 
          if ![Class, Range, Array, Regexp, Proc, Symbol].include?(klass)
            raise  Mongous::Error, "'field' arguments error. : #{ attr } on #{ symbol } at #{ call_from }"
          end
        end
      end

      items.each do |key, value|
        next    if [:default, :create, :update].include?(key) && [Proc, String, Numeric].include?(value.class)

        raise  Mongous::Error, "'field' options error. : #{key} on #{ symbol } at #{ call_from }"
      end

      items[:_attrs]  =  attrs
      fields[symbol.to_s]  =  items
    end

    def verify( *directives, &block )
      if !directives.empty?
        directives.each do |directive|
          symbols[directive]  =  true
        end
      elsif block
        m  =  /(.*?):(\d+)/.match( caller()[0] )
        call_from  =  [ m[1], m[2] ].join(":")
        blocks[call_from]  =  block
      else
        raise  Mongous::Error, "'verify' arguments error. need directives or block."
      end
    end

    def index( *symbols, **options )
      options[:background]  =  true    unless  options.has_key?(:background)
      keys  =  {}
      symbols.each do |symbol|
        keys[symbol]  =  1
      end
      indexes.push  <<  [keys, options]
    end

    def filter( symbol, filter_or_condition )
      case  filter_or_condition
      when  Filter
        filters[symbol]  =  filter_or_condition.to_condition
      when  Hash
        filters[symbol]  =  filter_or_condition
      else
        m  =  /(.*?):(\d+)/.match( caller()[0] )
        call_from  =  [ m[1], m[2] ].join(":")
        raise  Mongous::Error, "'filter' arguments error. : #{symbol}, #{filter_or_condition} at #{ call_from }"
      end
    end
  end
end
