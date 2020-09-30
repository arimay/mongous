
require  "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        String,  :must
  field  :author,       String
  field  :publisher,    String
  field  :style,        String,  %w[A4 A5 A6]
  field  :price,        Integer, (0..1_000_000)
  field  :page,         Integer, proc{ page % 4 == 0 }
  field  :publish_at,   Date,    &proc{ Date.today }
  field  :isbn,         String,  proc{ isbn? }
  field  :lang,         String,  &proc{ "ja" }

  verify :strict
  verify { having?( title ) }
  verify do
    having?( author ) | having?( publisher )
  end

  def isbn?
    isbn&.gsub(/\D*/, '')&.size == 13
  end
end


book  =  Book.new
book.title       =  "title strict"
book.author      =  "foobar"
book.publisher   =  nil
book.style       =  "A6"
book.price       =  300
book.page        =  300
# book.publish_at  =  nil  # (default)
book.isbn        =  "978-3-16-148410-0"
# book.lang        =  nil  # (default)
book.save


Book.each do |book|
  pp book
end

