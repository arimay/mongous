
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

Book.where( style: %w[A4 A5 A6] ).each do |book|
  p book
end
puts

Book.where( style: %w[A4 A5]).each do |book|
  p book
end
puts

Book.where( style: %w[A5] ).each do |book|
  p book
end
puts

