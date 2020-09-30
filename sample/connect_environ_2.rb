
require "mongous"

$client  =  Mongous.connect( ENV["MONGOLAB_URI"] || "mongodb://localhost:27017/test" )

class Book
  include  Mongous::Document
  set_client  $client
end


Book.each do |book|
  p book
end

