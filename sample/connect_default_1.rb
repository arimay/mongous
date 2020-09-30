
require "mongous"

Mongous.connect!( ["localhost:27017"], database: "test" )

class Book
  include  Mongous::Document
end


Book.each do |book|
  p book
end

