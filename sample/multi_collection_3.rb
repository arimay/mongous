
require "mongous"

Mongous.connect!

Mongous.attach!  :Book1
Mongous.attach!  :Book2
Mongous.attach!  :Book3

pp Book1.collection
pp Book2.collection
pp Book3.collection

Mongous.attach!  :Book1
Mongous.attach!  :Book2, :Book3

pp Book1.collection
pp Book2.collection
pp Book3.collection

Mongous.attach!  :Book1, :Book2, :Book3

pp Book1.collection
pp Book2.collection
pp Book3.collection

