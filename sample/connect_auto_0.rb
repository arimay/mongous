
require "mongous"

Mongous.document!  :Book

Book.each do |book|
  p book
end

