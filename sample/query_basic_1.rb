
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


book  =  Book.first
p book
puts

Book.each do |book|
  p book
end

