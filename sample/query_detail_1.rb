
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title
  field  :author
  field  :publisher
  field  :style
  field  :price
  field  :page
  field  :publish_at
  field  :isbn
  field  :lang

  verify :strict
end


pp Book.fields

