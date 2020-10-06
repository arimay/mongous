
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

#Item.find.skip(2).each do |item| p item; end; puts
Item.where[2].each do |item|
  p item
end
puts

#Item.find.limit(3).each do |item| p item; end; puts
Item.where[0,3].each do |item|
  p item
end
puts

#Item.find.skip(4).limit(5).each do |item| p item; end; puts
Item.where[4,5].each do |item|
  p item
end
puts

Item.where[4..8].each do |item|
  p item
end
puts

Item.where[4...9].each do |item|
  p item
end
puts

