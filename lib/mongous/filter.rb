
module Mongous
  class Filter
    def initialize( klass )
      @klass  =  klass
      @filter  =  {}
      @option  =  {}
    end

    def filter( _filter )
      hash  =  {}
      _filter.each do |key, item|
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
      @filter.merge!( hash )
      self.dup
    end

    def option( _option )
      self.option!( _option )
      self.dup
    end

    def option!( _option )
      @option.merge!( _option )
    end

    def projection( _projection )
      self.projection!( _projection )
      self.dup
    end
    alias  :select  :projection

    def projection!( _projection )
      @projection  =  _projection
    end

    def sort( _sort )
      self.sort!( _sort )
      self.dup
    end
    alias  :order  :sort

    def sort!( _sort )
      @sort  =  _sort
    end

    def skip( _skip )
      self.skip!( _skip )
      self.dup
    end
    alias  :offset  :skip

    def skip!( _skip )
      @skip  =  _skip
    end

    def limit( _limit )
      self.limit!( _limit )
      self.dup
    end

    def limit!( _limit )
      @limit  =  _limit
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

    def first
      doc  =  do_find.first
      @klass.new( doc )    if doc
    end

    def all
      do_find.map do |doc|
        @klass.new( doc )
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

