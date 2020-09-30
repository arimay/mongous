
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        :must
  field  :price,        Integer, (0..1_000_000)
end

begin
  book  =  Book.new
  book.title  =  "title price"
  book.price  =  -1
  book.save

rescue => e
  p e.message

end

