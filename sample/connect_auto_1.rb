
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


Book.each do |book|
  p book
end

