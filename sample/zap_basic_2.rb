
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

Book.where( title: "title 1" ).delete

