
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

doc  =  { title: "title basic 3", author: "Candy", size: "A6", price: 3000, page: 300 }
Book.create( **doc )

