
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        String,  :must
  field  :author,       String
  field  :publisher,    String
  field  :style,        String,  %w[hardcover softcover paperback]
  field  :size,         String,  /[AB]\d/
  field  :price,        Integer, (0..1_000_000)
  field  :page,         Integer, proc{ page > 0 }
  field  :isbn,         String,  proc{ isbn? }
  field  :lang,         String,  default: "en"
  field  :created_at,   Time,    create: proc{ Time.now }
  field  :updated_at,   Time,    update: proc{ Time.now }

  verify :strict
  verify { having?( title ) }
  verify do
    having?( author ) | having?( publisher )
  end

  def isbn?
    return  false    if isbn.nil?
    str  =  isbn.gsub(/\D*/, '')
    str.size == 13
  end
end

begin
  book  =  Book.new
  book.title  =  "title verify 1"
  book.author  =  "jane doe"
  book.style  =  "softcover"
  book.size  =  "A5"
  book.price  =  2000
  book.page  =  200
  book.isbn  =  "978-3-16-148410-0"
  book.save

rescue => e
  p e.message

end

