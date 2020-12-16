
require "mongous"

class Book
  include  Mongous::Document

  field  :title
  field  :author
  field  :publisher
  field  :style
  field  :size
  field  :price,      Integer
  field  :page,       Integer
  field  :isbn
  field  :lang
  field  :created_at, Time
  field  :updated_at, Time

  verify :strict
end

pp Book.fields

