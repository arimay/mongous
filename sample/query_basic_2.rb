
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

p book  =  Book.where( title: /title/ ).first
puts

p count  =  Book.where( title: /title/ ).count
puts

pp books  =  Book.where( title: /title/ ).all
puts

Book.where( title: /title/ ).each do |book|
  p book
end
puts

