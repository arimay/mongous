
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


book  =  Book.filter( title: "title 1" ).first
p book
puts

Book.filter( title: /title/ ).each do |book|
  p book
end

