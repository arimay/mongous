
require "mongous"

class Book
  include  Mongous::Document
end

p "book  =  Book.where( title: /title/ ).first"
p book  =  Book.where( title: /title/ ).first
puts

p "book  =  Book.where( title: /title/ ).last"
p book  =  Book.where( title: /title/ ).last
puts

p "count  =  Book.where( title: /title/ ).count"
p count  =  Book.where( title: /title/ ).count
puts

p "books  =  Book.where( title: /title/ ).all"
pp books  =  Book.where( title: /title/ ).all
puts

p "Book.where( title: /title/ ).each do |book|"
Book.where( title: /title/ ).each do |a_book|
  p a_book
end
puts

