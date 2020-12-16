
require "mongous"

Mongous.document!  :Book1

book  =  Book1.new
book.title       =  "book1"
book.save

book  =  Book1.where( title: "book1" ).first
book.author      =  "alice"
book.save

Book1.each do |book|
  pp book
end
puts

Book1.drop


Mongous.document!  :Book2, timestamp: true

book  =  Book2.new
book.title       =  "book2"
book.save

book  =  Book2.where( title: "book2" ).first
book.author      =  "bob"
book.save

Book2.each do |book|
  pp book
end
puts

Book2.drop

