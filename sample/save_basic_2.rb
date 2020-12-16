
require "mongous"

Mongous.document!  :Book

book  =  Book.new( title: "title basic 2", author: "Bob", size: "A5", price: 2000, page: 200 )
book.save

