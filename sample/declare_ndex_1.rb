
require  "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        String,  :must
  field  :author
  field  :publisher
  field  :style
  field  :price
  field  :page
  field  :publish_at
  field  :isbn
  field  :lang

  index  :title

  verify :strict
end


book  =  Book.new
book.title       =  "declare index 1"
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

