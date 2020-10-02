
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


book  =  Book.new( title: "title basic 2", author: "Bob", style: "A5", price: 2000, page: 200 )
book.save

