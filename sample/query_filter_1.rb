
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

(1..3).each do |n|
  unless  Book.where( title: "complex #{n}" ).first
    Book.create( title: "complex #{n}", author: (0x40 + n).chr, size: "A#{n + 3}", price: n * 1000, page: n * 100 )
  end
end
puts

filter1  =  Book.where( title: /comp/ )
filter2  =  Book.not( price: (2000...3000) )
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

