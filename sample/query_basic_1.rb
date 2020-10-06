
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

p book  =  Book.first
puts

p count  =  Book.count
puts

pp books  =  Book.all
puts

Book.each do |book|
  p book
end
puts

