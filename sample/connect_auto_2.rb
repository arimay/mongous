
require "mongous"

$client  =  Mongous.connect

class Book
  include  Mongous::Document
  self.client  =  $client
  self.collection_name  =  "Book"
end


Book.each do |book|
  p book
end

