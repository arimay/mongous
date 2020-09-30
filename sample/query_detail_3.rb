
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,                :must
  field  :author
  field  :publisher
  field  :style,                %w[ A4 A5 A6 ]
  field  :price,      Integer,  (0..1_000_000)
  field  :page,       Integer,  proc{ page > 0 }
  field  :publish_at, Date,     &proc{ Date.today }
  field  :isbn,                 proc{ isbn? }
  field  :lang,                 &proc{ "ja" }

  verify :strict

  def isbn?
    return  false    if isbn.nil?
    str  =  isbn.gsub(/\D*/, '')
    str.size == 13
  end
end

pp Book.fields

