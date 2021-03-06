
require "mongous"

class Card
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

COUNT = 1000

D0  =  Date.parse( "2020-01-01" )
T0  =  D0.to_time

Benchmark.bm 32 do |bm|
  if COUNT !=  Card.count
    Card.delete
    bm.report "create #{COUNT}" do
      (0...COUNT).each do |i|
          f  =  i.to_f
          s  =  i.to_s
          d  =  D0 + i
          t  =  T0 + i
          r  =  rand
          card  =  Card.create(
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

  bm.report "find a integer without index" do
    (0...COUNT).each do |i|
      Card.where( i1: i ).first
    end
  end
  bm.report "find a integer with    index" do
    (0...COUNT).each do |i|
      Card.where( i2: i ).first
    end
  end
  bm.report "find a float   without index" do
    (0...COUNT).each do |i|
      Card.where( f1: i.to_f ).first
    end
  end
  bm.report "find a float   with    index" do
    (0...COUNT).each do |i|
      Card.where( f2: i.to_f ).first
    end
  end
  bm.report "find a string  without index" do
    (0...COUNT).each do |i|
      Card.where( s1: i.to_s ).first
    end
  end
  bm.report "find a string  with    index" do
    (0...COUNT).each do |i|
      Card.where( s2: i.to_s ).first
    end
  end
  bm.report "find a date    without index" do
    (0...COUNT).each do |i|
      Card.where( d1: D0 + i ).first
    end
  end
  bm.report "find a date    with    index" do
    (0...COUNT).each do |i|
      Card.where( d2: D0 + i ).first
    end
  end
  bm.report "find a time    without index" do
    (0...COUNT).each do |i|
      Card.where( t1: T0 + i ).first
    end
  end
  bm.report "find a time    with    index" do
    (0...COUNT).each do |i|
      Card.where( t2: T0 + i ).first
    end
  end
end

