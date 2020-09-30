
require "mongous"

$client  =  Mongous.connect( ["localhost:27017"], database: "test" )

class Book
  include  Mongous::Document
  set_client  $client
end


Book.each do |book|
  p book
end

