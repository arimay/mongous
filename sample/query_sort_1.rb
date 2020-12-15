
require "mongous"

Mongous.attach! :Item

(0...10).each do |n|
  unless  Item.where( n: n ).first
    Item.create( n: n )
  end
end
puts

p "Item.each do |item|"
Item.each do |item|
  p item
end
puts

p "Item.where.sort(n: 1).each do |item|"
Item.where.sort(n: 1).each do |item|
  p item
end
puts

p "Item.where.sort(n: -1).each do |item|"
Item.where.sort(n: -1).each do |item|
  p item
end
puts

p "Item.where( n: (3...8) ).sort(n: -1).each do |item|"
Item.where( n: (3...8) ).sort(n: -1).each do |item|
  p item
end
puts

p "Item.where( n: [0,2,4,6,8] ).sort(n: -1).each do |item|"
Item.where( n: [0,2,4,6,8] ).sort(n: -1).each do |item|
  p item
end
puts

