
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


Book.filter( page: (100..300) ).each do |book|
  p book
end
puts

Book.filter( page: (100...300) ).each do |book|
  p book
end
puts

