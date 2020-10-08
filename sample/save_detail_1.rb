
require "mongous"

Mongous.connect!

class Book
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

book  =  Book.new
book.title  =  "title detail 1"
book.author  =  "Alice"
book.publisher  =  "Foobar"
book.style  =  "hardcover"
book.size  =  "A4"
book.price  =  1000
book.page  =  100
book.isbn  =  "978-3-16-148410-0"
book.lang  =  "en"
book.created_at  =  Time.now
book.updated_at  =  Time.now
book.save

