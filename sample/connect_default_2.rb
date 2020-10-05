
require "mongous"

$client  =  Mongous.connect( ["localhost:27017"], database: "test" )

class Book
  include  Mongous::Document
  self.client  =  $client
  self.collection_name  =  "Book"
end


Book.each do |book|
  p book
end

