
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

book  =  Book.new
book.title  =  "title basic 1"
book.author  =  "Alice"
book.style  =  "A4"
book.price  =  1000
book.page  =  100
book.save

