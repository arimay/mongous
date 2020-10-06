
require "mongous"

Mongous.connect!

class Label
  include  Mongous::Document
end

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

Label.where.projection( tag: 1 ).each do |label|
  p label
end
puts

Label.where.projection( _id: 0, n: 1 ).each do |label|
  p label
end
puts

Label.where.select( _id: 0, n: 1, tag: 1 ).each do |label|
  p label
end
puts

Label.where( n: [0,2,4,6,8] ).select( _id: 0, n: 1, tag: 1 ).each do |label|
  p label
end
puts

