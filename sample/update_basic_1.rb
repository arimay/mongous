
require "mongous"

Mongous.document!  :Book

Book.where( title: /title/ ).each do |book|
  book.price  =  (book.price || 50 ) * 2
  book.save
end
