
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        :must
  field  :author
  field  :publisher

  verify { having?( title ) } 
  verify do
    having?( author ) | having?( publisher )
  end
end

begin
  book  =  Book.new
  book.title  =  "title verify 2"
  book.save

rescue => e
  p e.message

end

