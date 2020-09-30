
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

Item.filter.sort(n: 1).each do |item|
  p item
end
puts

Item.filter.sort(n: -1).each do |item|
  p item
end
puts

Item.filter.order(n: -1).each do |item|
  p item
end
puts

Item.filter( n: (3...8) ).order(n: -1).each do |item|
  p item
end
puts

Item.filter( n: [0,2,4,6,8] ).order(n: -1).each do |item|
  p item
end
puts

