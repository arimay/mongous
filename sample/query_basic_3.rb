
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


Book.filter.option( projection: {_id: 0, title: 1, author: 1} ).each do |book|
  p book
end
puts

Book.filter( title: /title/ ).option( projection: {_id: 0, title: 1} ).each do |book|
  p book
end

