
require "mongous"

Mongous.connect!

class Item
  include  Mongous::Document
end

(0...10).each do |n|
  unless  Item.where( n: n ).first
    Item.create( n: n )
  end
end
puts

Item.each do |item|
  p item
end
puts

Item.where.sort(n: 1).each do |item|
  p item
end
puts

Item.where.sort(n: -1).each do |item|
  p item
end
puts

Item.where.order(n: -1).each do |item|
  p item
end
puts

Item.where( n: (3...8) ).order(n: -1).each do |item|
  p item
end
puts

Item.where( n: [0,2,4,6,8] ).order(n: -1).each do |item|
  p item
end
puts

