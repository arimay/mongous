
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


book  =  Book.new( title: "title basic 1", author: "Alice", style: "A4", price: 1000, page: 100 )
book.save

