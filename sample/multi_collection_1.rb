
require "mongous"

Mongous.connect!

class Book1
  include  Mongous::Document
end

class Book2
  include  Mongous::Document
end

class Book3
  include  Mongous::Document
end


pp Book1.collection
puts

pp Book2.collection
puts

pp Book3.collection
puts

