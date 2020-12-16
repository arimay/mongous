
require "mongous"

class Book
  include  Mongous::Document

  field  :title,        :must
  field  :style,        String,  %w[hardcover softcover paperback]
end

begin
  book  =  Book.new
  book.title  =  "title style"
  book.style  =  "newspaper"
  book.save

rescue => e
  p e.message

end

