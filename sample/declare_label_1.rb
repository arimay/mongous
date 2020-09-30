
require  "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title
  field  :author
  field  :publisher
  field  :style
  field  :price
  field  :page
  field  :publish_at
  field  :isbn
  field  :lang

  verify :strict
end


book  =  Book.new
book.title       =  "title label"
book.author      =  "foobar"
book.publisher   =  nil
book.style       =  "A5"
book.price       =  200
book.page        =  200
# book.publish_at  =  nil  # (default)
# book.isbn        =  "978-3-16-148410-0"
# book.lang        =  nil  # (default)
book.save


Book.each do |book|
  pp book
end

