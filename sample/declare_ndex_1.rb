
require  "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        String,  :must
  field  :author
  field  :publisher
  field  :style
  field  :size
  field  :price
  field  :page
  field  :isbn
  field  :lang
  field  :created_at
  field  :updated_at

  index  :title

  verify :strict
end


book  =  Book.new
book.title       =  "declare index 1"
book.author      =  "Candy"
book.publisher   =  nil
book.style       =  "paperback"
book.size        =  "A6"
book.price       =  300
book.page        =  300
book.isbn        =  "978-3-16-148410-0"
# book.lang        =  nil  # (default)
# book.created_at  =  nil  # (created)
# book.updated_at  =  nil  # (updated)
book.save


Book.each do |book|
  pp book
end

