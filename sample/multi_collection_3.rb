
require "mongous"

Mongous.document!  :Book1
Mongous.document!  :Book2
Mongous.document!  :Book3

pp Book1.collection
pp Book2.collection
pp Book3.collection

Mongous.document!  :Book1
Mongous.document!  :Book2, :Book3

pp Book1.collection
pp Book2.collection
pp Book3.collection

Mongous.document!  :Book1, :Book2, :Book3

pp Book1.collection
pp Book2.collection
pp Book3.collection

