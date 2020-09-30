
require "mongous"

Mongous.connect!

class Item
  include  Mongous::Document
end


(0...10).each do |n|
  if  item  =  Item.filter( n: n ).first
    item
  else
    Item.create( n: n )
  end
end
puts

Item.each do |item|
  p item
end
puts

Item.filter.skip(2).each do |item|
  p item
end
puts

Item.filter.limit(3).each do |item|
  p item
end
puts

Item.filter.skip(4).limit(5).each do |item|
  p item
end
puts

Item.filter.offset(4).limit(5).each do |item|
  p item
end
puts

