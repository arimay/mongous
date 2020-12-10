
require "mongous"

Mongous.attach! :Item

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

Item.where( n: (3...8) ).sort(n: -1).each do |item|
  p item
end
puts

Item.where( n: [0,2,4,6,8] ).sort(n: -1).each do |item|
  p item
end
puts

