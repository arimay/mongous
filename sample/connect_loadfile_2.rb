
require "mongous"

filepath  =  File.join( File.dirname(__FILE__), "connect_mongo.yml" )
$client  =  Mongous.connect( file: filepath, mode: ENV["RACK_ENV"] || "development" )

class Book
  include  Mongous::Document
  self.client  =  $client
  self.collection_name  =  "Book"
end


Book.each do |book|
  p book
end

