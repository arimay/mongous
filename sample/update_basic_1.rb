
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

Book.where( title: /title/ ).each do |book|
  book.price  =  (book.price || 50 ) * 2
  book.save
end
