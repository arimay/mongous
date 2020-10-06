
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

p count  =  Book.where.count
puts

p count  =  Book.where[0..4].count
puts

p count  =  Book.where[0...4].count
puts

p count  =  Book.where[0, 4].count
puts

p count  =  Book.where[5, 5].count
puts

pp books  =  Book.where[0, 2].all
puts

filter  =  Book.where( title: /title/ )
filter[0, 4].each do |book|
  p book
end
puts
filter[4, 4].each do |book|
  p book
end
puts

