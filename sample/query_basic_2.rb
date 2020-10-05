
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


p book  =  Book.filter( title: /title/ ).first
puts

p count  =  Book.filter( title: /title/ ).count
puts

pp books  =  Book.filter( title: /title/ ).all
puts

Book.filter( title: /title/ ).each do |book|
  p book
end
puts

