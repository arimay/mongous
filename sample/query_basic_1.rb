
require "mongous"

class Book
  include  Mongous::Document
end

p "book  =  Book.first"
p book  =  Book.first
puts

p "book  =  Book.last"
p book  =  Book.last
puts

p "count  =  Book.count"
p count  =  Book.count
puts

p "books  =  Book.all"
pp books  =  Book.all
puts

p "Book.each do |book|"
Book.each do |a_book|
  p a_book
end
puts

