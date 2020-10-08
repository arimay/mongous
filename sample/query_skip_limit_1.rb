
require "mongous"

Mongous.connect!

class Item
  include  Mongous::Document
end

(0...10).each do |n|
  unless  Item.where( n: n ).first
    Item.create( n: n, tag: [0x40 + n].pack("C") )
  end
end
puts

p count  =  Item.count
puts

p count  =  Item.where.count
puts

p count  =  Item.where[0..4].count
puts

p count  =  Item.where[0...4].count
puts

p count  =  Item.where[0, 4].count
puts

p count  =  Item.where[5, 5].count
puts

pp books  =  Item.where[0, 2].all
puts

filter  =  Item.where
filter[0, 4].each do |item|
  p item
end
puts
filter[4, 4].each do |item|
  p item
end
puts

