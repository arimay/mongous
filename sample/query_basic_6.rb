
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

Book.new( title: "complex 1", author: "Alice", style: "A4", price: 1000, page: 100 ).save
Book.new( title: "complex 2", author: "Bob",   style: "A5", price: 2000, page: 200 ).save
Book.new( title: "complex 3", author: "Candy", style: "A6", price: 3000, page: 300 ).save

filter1  =  Book.filter( title: /comp/ )
filter2  =  Book.not( author: /Candy/ )
filter3  =  Book.and( filter1, filter2 ).select( _id: 0 )
filter4  =  Book.or( filter1, filter2 ).select( _id: 0 )
p filter1.to_condition
p filter2.to_condition
p filter3.to_condition
p filter4.to_condition
puts

filter1.each do |book|
  p book
end
puts

filter2.each do |book|
  p book
end
puts

filter3.each do |book|
  p book
end
puts

filter4.each do |book|
  p book
end
puts

