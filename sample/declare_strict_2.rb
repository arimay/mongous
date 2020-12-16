
require  "mongous"

class Book
  include  Mongous::Document

  field  :title,        String,  :must
  field  :author,       String
  field  :publisher,    String,  :must
  field  :style,        String,  %w[hardcover softcover paperback]
  field  :size,         String,  /[AB]\d/
  field  :price,        Integer, (0..1_000_000)
  field  :page,         Integer, proc{ page % 4 == 0 }
  field  :isbn,         String,  proc{ isbn? }
  field  :lang,         String,  default: "en"
  field  :created_at,   Time,    create: proc{ Time.now }
  field  :updated_at,   Time,    update: proc{ Time.now }

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

