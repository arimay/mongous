
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title
  field  :author
  field  :publisher
  field  :style
  field  :price,      Integer
  field  :page,       Integer
  field  :publish_at, Date
  field  :isbn
  field  :lang

  verify :strict
end

pp Book.fields

