
require  "mongous"

class Book
  include  Mongous::Document

  field  :title
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

  verify :strict
end


book  =  Book.new
book.title       =  "declare label"
book.author      =  "Bob"
book.publisher   =  nil
book.style       =  "softcover"
book.size        =  "A5"
book.price       =  200
book.page        =  200
book.isbn        =  "978-3-16-148410-0"
# book.lang        =  nil  # (default)
# book.created_at  =  nil  # (created)
# book.updated_at  =  nil  # (updated)
book.save


Book.each do |book|
  pp book
end

