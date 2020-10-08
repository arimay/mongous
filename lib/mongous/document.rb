
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

    def having?( label )
      case  label
      when  NilClass
        false
      when  String
        !label.strip.empty?
      else
        true
      end
    end

    def getvalue_or_callproc( value_or_proc )
      case  value_or_proc
      when  Proc
        value_or_proc.call
      else
        value_or_proc
      end
    end

    def save
      if  @doc["_id"].nil? || self.class.collection.find( { "_id"=> @doc["_id"] } ).count == 0
        savemode  =  :create
      else
        savemode  =  :update
      end

      self.class.fields.each do |label, field|
        default_value  =  getvalue_or_callproc( field[:default] )
        _must  =  field[:_attrs].include?(:must)
        if  @doc.has_key?(label)
          if  !having?( @doc[label] )
            if  default_value
              self[label]  =  default_value
            elsif  _must
              raise  Mongous::Error, "must but unassigned field. : #{ label }"
            elsif  self.class.symbols[:strict]
              self[label]  =  nil
            end
          end
        else
          if  default_value
            self[label]  =  default_value
          elsif  _must
            raise  Mongous::Error, "must but unassigned field. : #{ label }"
          elsif  self.class.symbols[:strict]
            self[label]  =  nil
          end
        end

        case  savemode
        when  :create
          if  create_value  =  getvalue_or_callproc( field[:create] )
            self[label]  =  create_value
          end
        when  :update
          if  update_value  =  getvalue_or_callproc( field[:update] )
            self[label]  =  update_value
          end
        end
      end

      self.class.blocks.each do |call_from, block|
        if  !self.instance_eval( &block )
          raise  Mongous::Error, "violation detected on save. : #{ call_from }"
        end
      end

      case  savemode
      when  :create
        self.class.collection.insert_one( @doc )
      when  :update
        self.class.collection.update_one( { "_id"=> @doc["_id"] }, { '$set' => @doc } )
      end

      self
    end

    def []( label )
      label  =  label.to_s

      if  self.class.symbols[:strict]
        if  !(self.class.fields.keys.include?(label) || (label == "_id"))
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
      if  attrs  =  field[:_attrs]  ||  []
        attrs.each do |attr|
          if  attr.class == Class
            types  <<  attr
            attrs  -=  [attr]
            break
          end
        end
      end

      if  !types.empty?
        if  !(attrs & [:must, :not_null]).empty?
          if  !types.include?( value.class )
            raise  Mongous::Error, "invalid type. : #{ label } : #{ value.class }"
          end
        else
          if  !(types + [NilClass] ).include?( value.class )
            raise  Mongous::Error, "invalid type. : #{ label } : #{ value.class }"
          end
        end
      else
        if  !(attrs & [:must, :not_null]).empty?
          if  [NilClass].include?( value.class )
            raise  Mongous::Error, "invalid type. : #{ label } : #{ value.class }"
          end
        end
      end

      @doc[label]  =  value

      attrs.each do |attr|
        case  attr
        when  Proc
          if  !self.instance_eval( &attr )
            raise  Mongous::Error, "violation detected. : #{ label } : #{ value }"
          end
        when  Array
          if  !attr.include?( value )
            raise  Mongous::Error, "not include. : #{ label } : #{ value }"
          end
        when  Range
          if  !attr.cover?( value )
            raise  Mongous::Error, "out of range. : #{ label } : #{ value }"
          end
        when  Regexp
          if  !attr.match( value )
            raise  Mongous::Error, "unmatch regexp. : #{ label } : #{ value }"
          end
        end
      end
    end
  end
end
