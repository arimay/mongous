
require "mongous"

Mongous.document!  :Label

(0...10).each do |n|
  unless  Label.where( n: n ).first
    Label.create( n: n, tag: [0x40 + n].pack("C") )
  end
end
puts

p "Label.each do |label|"
Label.each do |label|
  p label
end
puts

p "Label.select( tag: 1 ).each do |label|"
Label.select( tag: 1 ).each do |label|
  p label
end
puts

p "Label.select( :tag ).each do |label|"
Label.select( :tag ).each do |label|
  p label
end
puts

p "Label.select( _id: 0, n: 1 ).each do |label|"
Label.select( _id: 0, n: 1 ).each do |label|
  p label
end
puts

p "Label.select( n: 1, tag: 1 ).each do |label|"
Label.select( n: 1, tag: 1 ).each do |label|
  p label
end
puts

p "Label.select( :n, :tag ).each do |label|"
Label.select( :n, :tag ).each do |label|
  p label
end
puts

p "Label.select( _id: 0, n: 1, tag: 1 ).where( n: [0,2,4,6,8] ).each do |label|"
Label.select( _id: 0, n: 1, tag: 1 ).where( n: [0,2,4,6,8] ).each do |label|
  p label
end
puts

