
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

book  =  Book.new
book.title       =  "declare compact"
book.author      =  "Alice"
book.publisher   =  nil
book.style       =  "hardcover"
book.size        =  "A4"
book.price       =  100
book.page        =  100
book.isbn        =  "978-3-16-148410-0"
# book.lang        =  nil # (default)
# book.created_at  =  nil # (created)
# book.updated_at  =  nil # (updated)
book.save

Book.each do |book|
  pp book
end

