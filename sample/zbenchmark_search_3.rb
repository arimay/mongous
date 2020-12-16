
require "mongous"

class Plate
  include  Mongous::Document
  field :i1, Integer
  field :i2, Integer
  field :f1, Float
  field :f2, Float
  field :s1, String
  field :s2, String
  field :d1, Date
  field :d2, Date
  field :t1, Time
  field :t2, Time
  field :r1, Float
  field :r2, Float

  index :i2, unique: true
  index :f2, unique: true
  index :s2, unique: true
  index :d2, unique: true
  index :t2, unique: true
  index :r2
end

require "benchmark"
require "date"

COUNT = 100000

D0  =  Date.parse( "2020-01-01" )
T0  =  D0.to_time

Benchmark.bm 40 do |bm|
  if COUNT !=  Plate.count
    Plate.delete
    bm.report "create #{COUNT}" do
      (0...COUNT).each do |i|
          f  =  i.to_f
          s  =  i.to_s
          d  =  D0 + i
          t  =  T0 + i
          r  =  rand
          card  =  Plate.create(
            i1: i,
            i2: i,
            f1: f,
            f2: f,
            s1: s,
            s2: s,
            d1: d,
            d2: d,
            t1: t,
            t2: t,
            r1: r,
            r2: r,
          )
      end
    end
  end

  bm.report "first,  order by asc   without index" do
    Plate.sort( r1: 1 ).first
  end
  bm.report "first,  order by desc  without index" do
    Plate.sort( r1: -1 ).first
  end
  bm.report "top 10, order by asc   without index" do
    Plate.sort( r1: 1 )[0,10].all
  end
  bm.report "top 10, order by desc  without index" do
    Plate.sort( r1: -1 )[0,10].all
  end
  bm.report "first,  order by asc   with    index" do
    Plate.sort( r2: 1 ).first
  end
  bm.report "first,  order by desc  with    index" do
    Plate.sort( r2: -1 ).first
  end
  bm.report "top 10, order by asc   with    index" do
    Plate.sort( r2: 1 )[0,10].all
  end
  bm.report "top 10, order by desc  with    index" do
    Plate.sort( r2: -1 )[0,10].all
  end
end

