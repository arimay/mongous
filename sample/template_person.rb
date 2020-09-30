
class Person
  include  Mongous::Document

  field  :fullname
  field  :username
  field  :age,        Integer
  field  :created_at, Date, &proc{ Date.today }

  verify :strict
end

