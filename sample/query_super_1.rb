
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


p book  =  Book.find.first
puts

Book.find.each do |book|
  p book
end
puts

Book.find( title: /title/ ).each do |book|
  p book
end
puts

Book.find( {}, { projection: {_id: 0} } ).each do |book|
  p book
end
puts

Book.find( {title: /title/}, { projection: {_id: 0} } ).each do |book|
  p book
end

