
require "mongous"

Mongous.attach!  :Book

Book.each do |book|
  p book
end

