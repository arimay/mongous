
require "mongous"

Mongous.document!  :Book

p "book  =  Book.find.first"
p book  =  Book.find.first
puts

p "Book.find.each do |book|"
Book.find.each do |a_book|
  p a_book
end
puts

p "Book.find( title: /title/ ).each do |book|"
Book.find( title: /title/ ).each do |a_book|
  p a_book
end
puts

p "Book.find( {}, { projection: {_id: 0} } ).each do |book|"
Book.find( {}, { projection: {_id: 0} } ).each do |a_book|
  p a_book
end
puts

p "Book.find( {title: /title/}, { projection: {_id: 0} } ).each do |book|"
Book.find( {title: /title/}, { projection: {_id: 0} } ).each do |a_book|
  p a_book
end

