
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

Book.where( size: %w[A4 A5 A6] ).each do |book|
  p book
end
puts

Book.where( size: %w[A4 A5]).each do |book|
  p book
end
puts

Book.where( size: %w[A5] ).each do |book|
  p book
end
puts

