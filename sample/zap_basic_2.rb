
require "mongous"

Mongous.connect!

class Item
  include  Mongous::Document
end

Item.where.delete

