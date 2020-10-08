
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,                :must
  field  :author
  field  :publisher
  field  :style,                %w[hardcover softcover paperback]
  field  :size,                 /[AB]\d/
  field  :price,      Integer,  (0..1_000_000)
  field  :page,       Integer,  proc{ page > 0 }
  field  :isbn,                 proc{ isbn? }
  field  :lang,                 default: "en"
  field  :created_at, Time,     create: proc{ Time.now }
  field  :updated_at, Time,     update: proc{ Time.now }

  verify :strict

  def isbn?
    return  false    if isbn.nil?
    str  =  isbn.gsub(/\D*/, '')
    str.size == 13
  end
end

pp Book.fields

