
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,                :must
  field  :author
  field  :publisher
  field  :style,                %w[ A4 A5 A6 ]
  field  :price,      Integer,  (0..1_000_000)
  field  :page,       Integer,  proc{ page > 0 }
  field  :publish_at, Date,     &proc{ Date.today }
  field  :isbn,                 proc{ isbn? }
  field  :lang,                 &proc{ "ja" }

  verify :strict

  def isbn?
    return  true    unless having? isbn
    str  =  isbn.gsub(/\D*/, '')
    str.size == 13
  end
end


book  =  Book.new
book.title  =  "title detail 3"
book.author  =  "Candy"
#book.publisher  =  "Foobar"
book.style  =  "A6"
book.price  =  3000
book.page  =  300
#book.publish_at  =  Date.today
book.isbn  =  "978-3-16-148410-0"
#book.lang
book.save

