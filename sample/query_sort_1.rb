
require "mongous"

Mongous.document!  :Mash

(0...10).each do |n|
  unless  Mash.where( n: n ).first
    r  =  rand
    Mash.create( n: n, r: r )
  end
end
puts

p "Mash.each do |mash|"
Mash.each do |mash|
  p mash
end
puts

p "Mash.sort(r: 1).each do |mash|"
Mash.sort(r: 1).each do |mash|
  p mash
end
puts

p "Mash.sort(r: -1).each do |mash|"
Mash.sort(r: -1).each do |mash|
  p mash
end
puts

p "Mash.where( n: (3...8) ).sort(r: -1).each do |mash|"
Mash.where( n: (3...8) ).sort(r: -1).each do |mash|
  p mash
end
puts

p "Mash.where( n: [0,2,4,6,8] ).sort(r: -1).each do |mash|"
Mash.where( n: [0,2,4,6,8] ).sort(r: -1).each do |mash|
  p mash
end
puts

