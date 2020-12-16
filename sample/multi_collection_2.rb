
require "mongous"

class Book1
  include  Mongous::Document
end

class Book2
  include  Mongous::Document

  field  :title
  field  :author
  field  :publisher
  field  :style
  field  :size
  field  :price
  field  :page
  field  :isbn
  field  :lang
  field  :created_at
  field  :updated_at

  verify :strict
end

class Book3
  include  Mongous::Document

  field  :title,                 :must
  field  :author
  field  :publisher,    String,  :must
  field  :style,        String,  %w[hardcover softcover paperback]
  field  :size,         String,  /[AB]\d/
  field  :price,        Integer, (0..1_000_000)
  field  :page,         Integer, proc{ page > 0 }
  field  :isbn,                  proc{ isbn? }
  field  :lang,         String,  default: "en"
  field  :created_at,   Time,    create: proc{ Time.now }
  field  :updated_at,   Time,    update: proc{ Time.now }

  verify :strict
  verify { having?( title ) }
  verify do
    having?( author ) | having?( publisher )
  end

  def isbn?
    isbn.gsub(/[\D]*/, '').size == 13
  end
end


pp Book1.fields
puts

pp Book2.fields
puts

pp Book3.fields
puts

