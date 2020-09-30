
require "mongous"

filepath  =  File.join( File.dirname(__FILE__), "connect_mongo.yml" )
$client  =  Mongous.connect( file: filepath, mode: ENV["RACK_ENV"] || "development" )

class Book
  include  Mongous::Document
  set_client  $client
end


Book.each do |book|
  p book
end

