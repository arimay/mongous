
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title
  field  :author
  field  :publisher
  field  :style
  field  :size
  field  :price
  field  :page
  field  :isbn
  field  :lang
  field  :created_at
  field  :updated_at

  verify :strict
end


pp Book.fields

