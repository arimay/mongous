
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,                :must
  field  :author
  field  :publisher
  field  :style,                %w[hardcover, softcover, paperback]
  field  :size,                 /[AB]\d/
  field  :price,      Integer,  (0..1_000_000)
  field  :page,       Integer,  proc{ page > 0 }
  field  :isbn,                 proc{ isbn? }
  field  :lang,                 default: "en"
  field  :created_at, Time,     create: proc{ Time.now }
  field  :updated_at, Time,     update: proc{ Time.now }

  verify :strict

  def isbn?
    return  true    unless having? isbn
    str  =  isbn.gsub(/\D*/, '')
    str.size == 13
  end
end

book  =  Book.new
book.title  =  "title detail 3"
book.author  =  "Candy"
book.publisher
book.style  =  "paperback"
book.size  =  "A6"
book.price  =  3000
book.page  =  300
book.isbn  =  "978-3-16-148410-0"
# book.lang
# book.created_at
# book.updated_at
book.save

