
require "mongous"

Mongous.document!  :Item

(0...10).each do |n|
  unless  Item.where( n: n ).first
    Item.create( n: n, tag: [0x40 + n].pack("C") )
  end
end
puts

p "Item.each do |item|"
Item.each do |item|
  p item
end
puts

#Item.find.skip(2).limit(1).each do |item| p item; end; puts
p "Item[2].each do |item|"
Item[2].each do |item|
  p item
end
puts

#Item.find.skip(2).each do |item| p item; end; puts
p "Item[2, 0].each do |item|"
Item[2, 0].each do |item|
  p item
end
puts

#Item.find.limit(3).each do |item| p item; end; puts
p "Item[0, 3].each do |item|"
Item[0, 3].each do |item|
  p item
end
puts

#Item.find.skip(4).limit(5).each do |item| p item; end; puts
p "Item[4, 5].each do |item|"
Item[4, 5].each do |item|
  p item
end
puts

p "Item[4..8].each do |item|"
Item[4..8].each do |item|
  p item
end
puts

p "Item[4...8].each do |item|"
Item[4...8].each do |item|
  p item
end
puts

