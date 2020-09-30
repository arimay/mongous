
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


book  =  Book.collection.find.first
p book
puts

Book.collection.find.each do |book|
  p book
end
puts

Book.collection.find( title: /title/ ).each do |book|
  p book
end
puts

Book.collection.find( {}, { projection: {_id: 0, title: 1, author: 1} } ).each do |book|
  p book
end
puts

Book.collection.find( {title: /title/}, { projection: {_id: 0, title: 1, author: 1} } ).each do |book|
  p book
end

