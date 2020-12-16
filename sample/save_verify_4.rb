
require "mongous"

class Book
  include  Mongous::Document

  field  :title,        :must
  field  :isbn,         proc{ isbn? }

  def isbn?
    return  true    unless  isbn
    str  =  isbn.gsub(/\D*/, '')
    str.size == 13
  end
end

begin
  book  =  Book.new
  book.title  =  "title isbn"
  book.isbn  =  "978-3-16-148410-00"
  book.save

rescue => e
  p e.message

end

