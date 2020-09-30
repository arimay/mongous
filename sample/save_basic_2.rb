
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


book  =  Book.new
book.title  =  "title basic 2"
book.author  =  "Bob"
book.style  =  "A5"
book.price  =  2000
book.page  =  200
book.save

