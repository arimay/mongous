
require "mongous"

Mongous.document!  :Book

book  =  Book.new
book.title  =  "title basic 1"
book.author  =  "Alice"
book.size  =  "A4"
book.price  =  1000
book.page  =  100
book.save

