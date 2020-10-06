
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        :must
  field  :page,         Integer,  proc{ page > 1 }
  field  :price,        Integer,  proc{ (price > 0) && (price < 10_000) }

end

begin
  book  =  Book.new
  book.title  =  "title over price"
  book.page  =  200
  book.price  =  20000
  book.save

rescue => e
  p e.message

end

