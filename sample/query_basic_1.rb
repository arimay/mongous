
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


p book  =  Book.first
puts

pp books  =  Book.all
puts

Book.each do |book|
  p book
end
puts

