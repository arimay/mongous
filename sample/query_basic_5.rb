
require "mongous"

Mongous.connect!

class Book
  include  Mongous::Document
end


Book.filter( page: (100..300) ).each do |book|
  p book
end
puts

Book.filter( page: (100...300) ).each do |book|
  p book
end
puts

exit  if RUBY_VERSION < "2.6"

Book.filter( page: (200..) ).each do |book|
  p book
end
puts

exit  if RUBY_VERSION < "2.7"

Book.filter( page: (..200) ).each do |book|
  p book
end
puts

Book.filter( page: (...300) ).each do |book|
  p book
end
puts

