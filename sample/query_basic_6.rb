
# use new syntax from ruby 2.7

require "mongous"

Mongous.document!  :Item

(0...10).each do |n|
  unless  Item.where( n: n ).first
    Item.create( n: n, tag: [0x40 + n].pack("C") )
  end
end
puts

p "Item.where( n: (2..5) ).select( _id: 0 ).each do |item|"
Item.where( n: (2..5) ).select( _id: 0 ).each do |item|
  p item
end
puts

p "Item.where( n: (2...5) ).select( _id: 0 ).each do |item|"
Item.where( n: (2...5) ).select( _id: 0 ).each do |item|
  p item
end
puts

p "Item.where( n: (..5) ).select( _id: 0 ).each do |item|"
Item.where( n: (..5) ).select( _id: 0 ).each do |item|
  p item
end
puts

p "Item.where( n: (...5) ).select( _id: 0 ).each do |item|"
Item.where( n: (...5) ).select( _id: 0 ).each do |item|
  p item
end
puts

p "Item.where( n: (2..) ).select( _id: 0 ).each do |item|"
Item.where( n: (2..) ).select( _id: 0 ).each do |item|
  p item
end
puts

p "Item.not( n: (..2) ).select( _id: 0 ).each do |item|"
Item.not( n: (..2) ).select( _id: 0 ).each do |item|
  p item
end
puts

p "Item.select( _id: 0 ).not( n: (..2) ).each do |item|"
Item.select( _id: 0 ).not( n: (..2) ).each do |item|
  p item
end
puts

