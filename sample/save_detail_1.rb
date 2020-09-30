
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title
  field  :author
  field  :publisher
  field  :style
  field  :price
  field  :page
  field  :publish_at
  field  :isbn
  field  :lang

  verify :strict
end


book  =  Book.new
book.title  =  "title detail 1"
book.author  =  "Alice"
book.publisher  =  "Foobar"
book.style  =  "A4"
book.price  =  1000
book.page  =  100
book.publish_at  =  Date.today
book.isbn  =  "978-3-16-148410-0"
book.lang  =  "en"
book.save

