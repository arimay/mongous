
module Mongous
  module Extention
    def count
      self.collection.estimated_document_count
    end

    def all
      self.collection.find.map do |doc|
        self.new( **doc )
      end
    end

    def each( &block )
      all.each( &block )
    end

    def map( &block )
      all.map( &block )
    end

    def delete
      self.collection.delete_many({})
    end

    def attach( collection_name )
      Filter.new( self ).attach( collection_name )
    end

    def []( nth_or_range, len = nil )
      Filter.new( self )[ nth_or_range, len ]
    end

    def first
      Filter.new( self ).first
    end

    def last
      Filter.new( self ).last
    end

    def select( *keys, **hash )
      Filter.new( self ).select( *keys, **hash )
    end

    def where( filter = nil, **conditions )
      condition  =  normalize( filter, conditions )
      Filter.new( self ).where( condition )
    end

    def not( filter = nil, **conditions )
      raise  Mongous::Error, "Unset args for #{self}.not."    if filter.nil? && conditions.empty?

      condition  =  normalize( filter, conditions )
      Filter.new( self ).not( condition )
    end

    def and( *filters )
      raise  Mongous::Error, "Unset args for #{self}.and."    if filters.empty?

      conditions  =  filters.map do |filter|
        normalize( filter, {} )
      end
      Filter.new( self ).where({"$and" => conditions})
    end

    def or( *filters )
      raise  Mongous::Error, "Unset args for #{self}.or."    if filters.empty?

      conditions  =  filters.map do |filter|
        normalize( filter, {} )
      end
      Filter.new( self ).where({"$or" => conditions})
    end

    def normalize( filter, conditions )
      condition  =  case  filter
      when  Filter
        filter.to_condition
      when  Symbol
        case  _filter  =  filters[filter]
        when  Filter
          _filter.to_condition
        when  Hash
          _filter
        end
      when  NilClass
        Filter.new( self ).where( **conditions ).to_condition
      else
        caller_method  =  /`(.*?)'/.match( caller()[0] )[1]
        raise  Mongous::Error, "Invalid args for #{self}.#{ caller_method }. : #{filter}, #{conditions}"
      end
    end
  end
end

module Mongous
  class Filter
    def initialize( klass )
      @klass  =  klass
      @filter  =  {}
      @option  =  {}
    end

    def attach( collection_name )
      w  =  self.dup
      w.instance_variable_set( :@collection_name, collection_name.to_s )
      w
    end

    def build_condition( conditions )
      hash  =  {}
      conditions.each do |key, item|
        case  key
        when  /\$(and|or|nor)/
          hash[key]  =  item

        else
          case  item
          when  Array
            hash[key]  =  {"$in"=>item}

          when  Range
            _begin_oper  =  "$gte"
            _end_oper  =  item.exclude_end?  ?  "$lt"  :  "$lte"

            if      item.begin  &&   item.end
              hash[key]  =  { _begin_oper => item.begin, _end_oper => item.end }

            elsif  !item.begin  &&   item.end
              hash[key]  =  { _end_oper => item.end }

            elsif   item.begin  &&  !item.end
              hash[key]  =  { _begin_oper => item.begin }

            else
              raise  Mongous::Error, "invalid range. :  #{ item }"

            end

          else
            hash[key]  =  item

          end
        end
      end
      hash
    end

    def where( conditions )
      hash  =  build_condition( conditions )
      w  =  self.dup
      w.instance_variable_set( :@filter, @filter.merge( hash ) )
      w
    end

    def not( conditions )
      hash  =  build_condition( conditions )
      w  =  self.dup
      w.instance_variable_set( :@filter, @filter.merge( {"$nor" => [hash]} ) )
      w
    end

    def to_condition
      @filter.dup
    end

    def option( _option )
      w  =  self.dup
      w.instance_variable_set( :@option, @option.merge( _option ) )
      w
    end

    def select( *keys, **hash )
      if not keys.empty?
        _projection  =  Hash[ keys.zip( Array.new(keys.length, 1) ) ]
      elsif not hash.empty?
        _projection  =  hash
      else
        _projection  =  nil
      end
      w  =  self.dup
      w.instance_variable_set( :@projection, _projection )
      w
    end

    def sort( *keys, **hash )
      if not keys.empty?
        _sort  =  Hash[ keys.zip( Array.new( keys.length, 1 ) ) ]
      elsif not hash.empty?
        _sort  =  hash
      else
        _sort  =  nil
      end
      w  =  self.dup
      w.instance_variable_set( :@sort, _sort )
      w
    end

    def []( nth_or_range, len = nil )
      case  nth_or_range
      when  Integer
        _skip  =  nth_or_range

        if  len.is_a?(NilClass)
          _limit  =  1
        elsif  len.is_a?(Integer) && len == 0
          _limit  =  nil
        elsif  len.is_a?(Integer) && len > 0
          _limit  =  len
        else
          raise  Mongous::Error, "invalid len. :  #{ len }"
        end

      when  Range
        from  =  nth_or_range.begin
        raise  Mongous::Error, "invalid range. :  #{ nth_or_range }"    unless  from.is_a? Integer

        to    =  nth_or_range.end
        raise  Mongous::Error, "invalid range. :  #{ nth_or_range }"    unless  to.is_a? Integer

        to  -=  1    if nth_or_range.exclude_end?
        _skip  =  from
        _limit  =  to - from + 1

      else
        raise  Mongous::Error, "invalid class. :  #{ nth_or_range }"

      end

      w  =  self.dup
      w.instance_variable_set( :@skip, _skip )
      w.instance_variable_set( :@limit, _limit )
      w
    end

    def exec_query
      _filter  =  @filter
      _option  =  @option.dup
      _option[:projection]  =  @projection    if @projection
      found  =  @klass.collection( @collection_name ).find( _filter, _option )
      found  =  found.sort( @sort )    if  @sort
      found  =  found.skip( @skip )    if  @skip
      found  =  found.limit( @limit )    if  @limit
      found
    end

    def count
      found  =  @klass.collection.find( @filter )
      found  =  found.skip( @skip )    if  @skip
      found  =  found.limit( @limit )    if  @limit
      _count  =  found.count_documents
      if  @skip
        if  @skip > _count
          0
        elsif  @limit
          [_count - @skip, @limit].min
        else
          _count - @skip
        end
      else
        if  @limit
          [_count, @limit].min
        else
          _count
        end
      end
    end

    def first
      _filter  =  @filter
      _option  =  @option.dup
      _option[:projection]  =  @projection    if @projection
      found  =  @klass.collection( @collection_name ).find( _filter, _option )
      _order  =  @sort  ||  { _id: 1 }
      doc  =  found.sort( _order ).first
      @klass.new( **doc )    if doc
    end

    def last
      _filter  =  @filter
      _option  =  @option.dup
      _option[:projection]  =  @projection    if @projection
      found  =  @klass.collection( @collection_name ).find( _filter, _option )
      _order  =  {}
      ( @sort  ||  {_id: 1} ).each do |k,v|
        _order[k]  =  - v
      end
      doc  =  found.sort( _order ).first
      @klass.new( **doc )    if doc
    end

    def all
      exec_query.map do |doc|
        @klass.new( **doc )
      end
    end

    def each( &block )
      all.each( &block )
    end

    def map( &block )
      all.map( &block )
    end

    def delete
      @klass.collection.delete_many( @filter )
    end
  end
end

