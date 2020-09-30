
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title
  field  :author
  field  :publisher
  field  :style
  field  :price,      Integer
  field  :page,       Integer
  field  :publish_at, Date
  field  :isbn
  field  :lang

  verify :strict
end


book  =  Book.new
book.title  =  "title detail 2"
book.author  =  "Bob"
book.publisher  =  "Foobar"
book.style  =  "A5"
book.price  =  2000
book.page  =  200
book.publish_at  =  Date.today
book.isbn  =  "978-3-16-148410-0"
book.lang  =  "en"
book.save

