
require "mongous"

$client  =  Mongous.connect( ENV["MONGOLAB_URI"] || "mongodb://localhost:27017/test" )

class Book
  include  Mongous::Document
  self.client  =  $client
  self.collection_name  =  "Book"
end


Book.each do |book|
  p book
end

