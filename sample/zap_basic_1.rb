
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end

Book.delete

