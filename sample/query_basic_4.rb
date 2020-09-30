
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


Book.filter( style: %w[A4 A5 A6] ).each do |book|
  p book
end
puts

Book.filter( style: %w[A4 A5]).each do |book|
  p book
end
puts

Book.filter( style: %w[A5] ).each do |book|
  p book
end
puts

