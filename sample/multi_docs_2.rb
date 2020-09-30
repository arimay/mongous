
require "mongous"

Mongous.connect!

class Book1
  include  Mongous::Document
end

class Book2
  include  Mongous::Document

  field  :title
  field  :publisher
  field  :author
  field  :style
  field  :price
  field  :page
  field  :publish_at
  field  :isbn
  field  :lang

  verify :strict
end

class Book3
  include  Mongous::Document

  field  :title,                :must
  field  :author,               
  field  :publisher,            
  field  :price,      Integer,  (0..1_000_000)
  field  :page,       Integer,  proc{ page > 0 }
  field  :publish_at, Date,     &proc{ Date.today }
  field  :isbn,                 proc{ isbn? }
  field  :lang,                 &proc{ "ja" }

  verify :strict
  verify { having?( title ) }
  verify do
    having?( author ) | having?( publisher )
  end

  def isbn?
    isbn&.gsub(/[\D]*/, '').size == 13
  end
end


pp Book1.fields
puts

pp Book2.fields
puts

pp Book3.fields
puts

