
require "mongous"

Mongous.attach! :Item

(0...10).each do |n|
  unless  Item.where( n: n ).first
    Item.create( n: n, tag: [0x40 + n].pack("C") )
  end
end
puts

p count  =  Item.count
puts

p count  =  Item[0..4].count
puts

p count  =  Item[0...4].count
puts

p count  =  Item[0, 4].count
puts

p count  =  Item[5, 5].count
puts

pp books  =  Item[0, 2].all
puts

Item[0, 4].each do |item|
  p item
end
puts

Item[4, 4].each do |item|
  p item
end
puts

