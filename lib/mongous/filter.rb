
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

    def sort( *keys, **hash )
      Filter.new( self ).sort( *keys, **hash )
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
      case  filter
      when  Filter
        filter.to_condition
      when  Symbol
        case  ( new_filter  =  filters[filter] )
        when  Filter
          new_filter.to_condition
        when  Hash
          new_filter
        end
      when  NilClass
        Filter.new( self ).where( conditions ).to_condition
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
            begin_oper  =  "$gte"
            end_oper  =  item.exclude_end?  ?  "$lt"  :  "$lte"

            if      item.begin  &&   item.end
              hash[key]  =  { begin_oper => item.begin, end_oper => item.end }

            elsif  !item.begin  &&   item.end
              hash[key]  =  { end_oper => item.end }

            elsif   item.begin  &&  !item.end
              hash[key]  =  { begin_oper => item.begin }

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

    def where( conditions = {} )
      hash  =  build_condition( conditions )
      w  =  self.dup
      w.instance_variable_set( :@filter, @filter.merge( hash ) )
      w
    end

    def not( conditions = {} )
      hash  =  build_condition( conditions )
      w  =  self.dup
      w.instance_variable_set( :@filter, @filter.merge( {"$nor" => [hash]} ) )
      w
    end

    def to_condition
      @filter.dup
    end

    def option( new_option )
      w  =  self.dup
      w.instance_variable_set( :@option, @option.merge( new_option ) )
      w
    end

    def select( *keys, **hash )
      if not keys.empty?
        new_projection  =  Hash[ keys.zip( Array.new(keys.length, 1) ) ]
      elsif not hash.empty?
        new_projection  =  hash
      else
        new_projection  =  nil
      end
      w  =  self.dup
      w.instance_variable_set( :@projection, new_projection )
      w
    end

    def sort( *keys, **hash )
      if not keys.empty?
        new_sort  =  Hash[ keys.zip( Array.new( keys.length, 1 ) ) ]
      elsif not hash.empty?
        new_sort  =  hash
      else
        new_sort  =  nil
      end
      w  =  self.dup
      w.instance_variable_set( :@sort, new_sort )
      w
    end

    def []( nth_or_range, len = nil )
      case  nth_or_range
      when  Integer
        new_skip  =  nth_or_range

        if  len.is_a?(NilClass)
          new_limit  =  1
        elsif  len.is_a?(Integer) && len == 0
          new_limit  =  nil
        elsif  len.is_a?(Integer) && len > 0
          new_limit  =  len
        else
          raise  Mongous::Error, "invalid len. :  #{ len }"
        end

      when  Range
        from  =  nth_or_range.begin
        raise  Mongous::Error, "invalid range. :  #{ nth_or_range }"    unless  from.is_a? Integer

        to    =  nth_or_range.end
        raise  Mongous::Error, "invalid range. :  #{ nth_or_range }"    unless  to.is_a? Integer

        to  -=  1    if nth_or_range.exclude_end?
        new_skip  =  from
        new_limit  =  to - from + 1

      else
        raise  Mongous::Error, "invalid class. :  #{ nth_or_range }"

      end

      w  =  self.dup
      w.instance_variable_set( :@skip, new_skip )
      w.instance_variable_set( :@limit, new_limit )
      w
    end

    def exec_query
      new_filter  =  @filter
      new_option  =  @option.dup
      new_option[:projection]  =  @projection    if @projection
      found  =  @klass.collection( @collection_name ).find( new_filter, new_option )
      found  =  found.sort( @sort )    if  @sort
      found  =  found.skip( @skip )    if  @skip
      found  =  found.limit( @limit )    if  @limit
      found
    end

    def count
      found  =  @klass.collection.find( @filter )
      found  =  found.skip( @skip )    if  @skip
      found  =  found.limit( @limit )    if  @limit
      new_count  =  found.count_documents
      if  @skip
        if  @skip > new_count
          0
        elsif  @limit
          [new_count - @skip, @limit].min
        else
          new_count - @skip
        end
      else
        if  @limit
          [new_count, @limit].min
        else
          new_count
        end
      end
    end

    def first
      new_filter  =  @filter
      new_option  =  @option.dup
      new_option[:projection]  =  @projection    if @projection
      found  =  @klass.collection( @collection_name ).find( new_filter, new_option )
      new_order  =  @sort  ||  { _id: 1 }
      doc  =  found.sort( new_order ).first
      @klass.new( **doc )    if doc
    end

    def last
      new_filter  =  @filter
      new_option  =  @option.dup
      new_option[:projection]  =  @projection    if @projection
      found  =  @klass.collection( @collection_name ).find( new_filter, new_option )
      new_order  =  {}
      ( @sort  ||  {_id: 1} ).each do |k,v|
        new_order[k]  =  - v
      end
      doc  =  found.sort( new_order ).first
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

