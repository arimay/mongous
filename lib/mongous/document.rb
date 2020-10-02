
module Mongous
  module Document
    class  <<  self
      def included( klass )
        klass.extend  Extention
      end
    end

    def initialize( **doc )
      @doc  =  {}
      doc.each do |label, value|
        label  =  label.to_s
        @doc[label]  =  value
      end
    end

    def method_missing( sym, *args, **opts, &block )
      m  =  /\A(\w+)([=])?\Z/.match( sym.to_s )
      if  args.size == 0 && m[2].nil?
        self[ m[1] ]
      elsif  args.size == 1 && !m[2].nil?
        self[ m[1] ]  =  args.shift
      else
        raise  Mongous::Error, "invalid parameter. #{sym} #{args.join(', ')}"
      end
    end

    def having?( value )
      case  value
      when  NilClass
        false
      when  String
        !value.strip.empty?
      else
        true
      end
    end

    def save
      self.class.fields.each do |label, field|
        _must  =  field[:_args].include?(:must)
        if  @doc.has_key?(label)
          if  _must  &&  !having?( @doc[label] )
            raise  Mongous::Error, "must and not having field. : #{ label }"
          end
        else
          if  block  =  field[:_block]
            self[label]  =  block.call
          elsif  _must
            raise  Mongous::Error, "must and unassigned field. : #{ label }"
          elsif  self.class.symbols[:strict]
            self[label]  =  nil
          end
        end
      end

      self.class.blocks.each do |call_from, block|
        if  !self.instance_eval( &block )
          raise  Mongous::Error, "violation detected on save. : #{ call_from }"
        end
      end

      if  @doc["_id"]
        _filter  =  { "_id"=> @doc["_id"] }
        if  self.class.collection.find( _filter ).first
          self.class.collection.update_one( _filter, { '$set' => @doc } )
          return  self
        end
      end

      self.class.collection.insert_one( @doc )
      self
    end

    def []( label )
      label  =  label.to_s

      if  self.class.symbols[:strict]
        if  !self.class.fields.keys.include?(label)
          raise  Mongous::Error, "undefined field. : #{ label }"
        end
      end

      return  @doc[label]    if @doc.has_key?(label)

      field  =  self.class.fields[label]
      return  nil    if field.nil?

      case  default  =  field[:default]
      when  Proc
        self.instance_eval( &default )
      else
        default
      end
    end

    def []=( label, value )
      label  =  label.to_s
      if  self.class.symbols[:strict]
        labels  =  ["_id"] + self.class.fields.keys
        if  !labels.include?( label )
          raise  Mongous::Error, "undefined field. : #{ label }"
        end
      end

      field  =  self.class.fields[label]
      return  @doc[label]  =  value    if field.nil?

      types  =  []
      if  args  =  field[:_args]  ||  []
        args.each do |arg|
          if  arg.class == Class
            types  <<  arg
            args  -=  [arg]
            break
          end
        end
      end

      if  !types.empty?
        if  !(args & [:must, :not_null]).empty?
          if  !types.include?( value.class )
            raise  Mongous::Error, "invalid type. : #{ label } : #{ value.class }"
          end
        else
          if  !(types + [NilClass] ).include?( value.class )
            raise  Mongous::Error, "invalid type. : #{ label } : #{ value.class }"
          end
        end
      else
        if  !(args & [:must, :not_null]).empty?
          if  [NilClass].include?( value.class )
            raise  Mongous::Error, "invalid type. : #{ label } : #{ value.class }"
          end
        end
      end

      @doc[label]  =  value

      args.each do |arg|
        case  arg
        when  Proc
          if  !self.instance_eval( &arg )
            raise  Mongous::Error, "violation detected. : #{ label } : #{ value }"
          end
        when  Array
          if  !arg.include?( value )
            raise  Mongous::Error, "not include. : #{ label } :#{ value }"
          end
        when  Range
          if  !arg.cover?( value )
            raise  Mongous::Error, "out of range. : #{ label } :#{ value }"
          end
        end
      end
    end
  end
end
