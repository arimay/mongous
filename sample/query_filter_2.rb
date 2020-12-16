
require "mongous"

class Book
  include  Mongous::Document

  filter  :title1, { title: /filter/ }
  filter  :price1, { price: (2000..3000) }
  filter  :page1,  where( size: %w[A3 A4] )
end

(1..5).each do |n|
  unless  Book.where( title: "filter #{n}" ).first
    Book.create( title: "filter #{n}", author: (0x40 + n).chr, size: "A#{n + 3}", price: n * 1000, page: n * 100 )
  end
end
puts

filter1  =  Book.where( :price1 )
filter2  =  Book.not( :page1 )
filter3  =  Book.and( :title1, filter1, filter2 ).select( _id: 0 )
filter4  =  Book.and( :title1, Book.or( filter1, filter2 ) ).select( _id: 0 )
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

