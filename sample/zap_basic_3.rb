
require "mongous"

Mongous.connect!

class Card
  include  Mongous::Document
end

Card.delete

