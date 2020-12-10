
require "mongous"

Mongous.attach! :Label

(0...10).each do |n|
  unless  Label.where( n: n ).first
    Label.create( n: n, tag: [0x40 + n].pack("C") )
  end
end
puts

Label.each do |label|
  p label
end
puts

Label.select( tag: 1 ).each do |label|
  p label
end
puts

Label.select( :tag ).each do |label|
  p label
end
puts

Label.select( _id: 0, n: 1 ).each do |label|
  p label
end
puts

Label.select( n: 1, tag: 1 ).each do |label|
  p label
end
puts

Label.select( :n, :tag ).each do |label|
  p label
end
puts

Label.select( _id: 0, n: 1, tag: 1 ).where( n: [0,2,4,6,8] ).each do |label|
  p label
end
puts

