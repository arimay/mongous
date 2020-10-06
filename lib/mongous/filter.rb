
module Mongous
  module Extention
    def count
      self.collection.find.count
    end

    def first
      doc  =  self.collection.find.first
      self.new( **doc )    if doc
    end

    def all
      self.collection.find.map do |doc|
        self.new( **doc )
      end
    end

    def each( &block )
      all.each( &block )
    end

    def delete
      self.collection.delete_many({})
    end

    def where( filter = nil, **conditions )
      condition  =  normalize( filter, conditions )
      Filter.new( self ).where( condition )
    end

    def not( filter = nil, **conditions )
      raise  Mongous::Error, "Unset args for #{self}.not."    if filter.nil? && conditions.empty?

      condition  =  normalize( filter, conditions )
      Filter.new( self ).where({"$nor" => [condition]})
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

    def where( conditions )
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
      @filter.merge!( hash )
      self.dup
    end

    def to_condition
      @filter.dup
    end

    def option( _option )
      @option.merge!( _option )
      self.dup
    end

    def projection( _projection )
      @projection  =  _projection
      self.dup
    end
    alias  :select  :projection

    def sort( _sort )
      @sort  =  _sort
      self.dup
    end
    alias  :order  :sort

    def []( nth_or_range, len = nil )
      case  nth_or_range
      when  Integer
        @skip  =  nth_or_range

        if  len
          raise  Mongous::Error, "invalid len. :  #{ len }"    if  !len.is_a? Integer || len <= 0
          @limit  =  len
        end

      when  Range
        from  =  nth_or_range.begin
        raise  Mongous::Error, "invalid range. :  #{ nth_or_range }"    unless  from.is_a? Integer

        to    =  nth_or_range.end
        raise  Mongous::Error, "invalid range. :  #{ nth_or_range }"    unless  to.is_a? Integer

        to  -=  1    if nth_or_range.exclude_end?
        @skip  =  from
        @limit  =  to - from + 1

      else
        raise  Mongous::Error, "invalid class. :  #{ nth_or_range }"

      end

      self.dup
    end

    def do_find
      _filter  =  @filter
      _option  =  @option
      _option[:projection]  =  @projection    if @projection
      found  =  @klass.collection.find( _filter, _option )
      found  =  found.sort( @sort )    if  @sort
      found  =  found.skip( @skip )    if  @skip
      found  =  found.limit( @limit )    if  @limit
      found
    end

    def count
      _count  =  do_find.count
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
      doc  =  do_find.first
      @klass.new( **doc )    if doc
    end

    def all
      do_find.map do |doc|
        @klass.new( **doc )
      end
    end

    def each( &block )
      all.each( &block )
    end

    def delete
      _filter  =  @filter
      @klass.collection.delete_many( _filter )
    end
  end
end

