
require  "mongous"

Mongous.connect!

class Book
  include  Mongous::Document

  field  :title,        String,  :must
  field  :author,       String
  field  :publisher,    String,  :must
  field  :style,        String,  %w[A4 A5 A6]
  field  :price,        Integer, (0..1_000_000)
  field  :page,         Integer, proc{ page % 4 == 0 }
  field  :isbn,         String,  proc{ isbn? }
  field  :lang,         String,  default: "en"
  field  :created_at,   Time,    create: ->(){ Time.now }
  field  :updated_at,   Time,    update: ->(){ Time.now }

  verify :strict

  def isbn?
    true
  end
end


Book.each do |book|
  begin
    pp book
    book.save     # cause exception when detected violation.
  rescue => e
    p e.message
  end
end

