
require "mongous"

$client  =  Mongous.connect

class Book
  include  Mongous::Document
  set_client  $client
end


Book.each do |book|
  p book
end

