
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        :must
  field  :style,        String,  ["A4","A5","A6"]
end

begin
  book  =  Book.new
  book.title  =  "title isbn"
  book.style  =  "B5"
  book.save

rescue => e
  p e.message

end

