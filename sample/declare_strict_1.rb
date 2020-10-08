
require  "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        String,  :must
  field  :author,       String
  field  :publisher,    String
  field  :style,        String,  %w[hardcover softcover paperback]
  field  :size,         String,  /[AB]\d/
  field  :price,        Integer, (0..1_000_000)
  field  :page,         Integer, proc{ page % 4 == 0 }
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
    isbn.gsub(/\D*/, '').size == 13
  end
end


book  =  Book.new
book.title       =  "declare strict"
book.author      =  "David"
book.publisher   =  nil
book.style       =  "paperback"
book.size        =  "A7"
book.price       =  400
book.page        =  400
book.isbn        =  "978-3-16-148410-0"
# book.lang        =  nil  # (default)
# book.created_at  =  nil  # (create)
# book.updated_at  =  nil  # (update)
book.save


Book.each do |book|
  pp book
end

