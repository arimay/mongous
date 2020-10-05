
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


p count  =  Book.filter.count
puts

p count  =  Book.filter[0..4].count
puts

p count  =  Book.filter[0...4].count
puts

p count  =  Book.filter[0, 4].count
puts

p count  =  Book.filter[20,10].count
puts

pp books  =  Book.filter[0, 2].all
puts

filter  =  Book.filter( title: /title/ )
filter[0, 4].each do |book|
  p book
end
puts
filter[4, 4].each do |book|
  p book
end
puts

