
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        :must
  field  :size,         String,  /[AB]\d/
end

begin
  book  =  Book.new
  book.title  =  "title size"
  book.size  =  "C5"
  book.save

rescue => e
  p e.message

end

