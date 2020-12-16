
require "mongous"

class Book
  include  Mongous::Document
end

Book.where.option( projection: {_id: 0, title: 1, author: 1} ).each do |book|
  p book
end
puts

Book.where( title: /title/ ).option( projection: {_id: 0, title: 1} ).each do |book|
  p book
end

