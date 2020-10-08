
RSpec.describe "Mongous::Document: verify detail." do
  it '#verify step by step' do
    Mongous::connect! ["localhost:27017"], database: "admin"
    class Book
      include  Mongous::Document

      field  :title,        String,  :must
      field  :author,       String
      field  :publisher,    String
      field  :style,        String,  %w[hardcover softcover paperback]
      field  :size,         String,  /[AB]\d/
      field  :price,        Integer, (0..1_000_000)
      field  :page,         Integer, proc{ page > 0 }
      field  :isbn,         String,  proc{ isbn? }
      field  :lang,         String,  default: "en"
      field  :created_at,   Time,    create: proc{ Time.now }
      field  :updated_at,   Time,    update: proc{ Time.now }

      verify :strict
      verify { having?( title ) }
      verify do
        having?( author ) | having?( publisher )
      end

      def isbn?
        return  false    if isbn.nil?
        str  =  isbn.gsub(/\D*/, '')
        str.size == 13
      end
    end

    begin
      book1  =  Book.new
      book1._id     =  Time.now.to_s
      book1.title   =  "verify 1"
      book1.author  =  "jane doe"
      book1.style   =  "softcover"
      book1.size    =  "A5"
      book1.price   =  2000
      book1.page    =  200
      book1.isbn    =  "978-3-16-148410-0"
      book1.lang    =  nil
      book1.save

      book2  =  Book.where( title: "verify 1" ).first
      expect( book2._id    ).to  eq( book1._id    )
      expect( book2.title  ).to  eq( book1.title  )
      expect( book2.author ).to  eq( book1.author )
      expect( book2.style  ).to  eq( book1.style  )
      expect( book2.size   ).to  eq( book1.size   )
      expect( book2.price  ).to  eq( book1.price  )
      expect( book2.page   ).to  eq( book1.page   )
      expect( book2.isbn   ).to  eq( book1.isbn   )
      expect( book2.lang   ).to  eq( "en"         )

    rescue => e
      p e.message

    end

    Book.delete
    Object.send( :remove_const, :Book )
  end

  it '#verify on create' do
    Mongous::connect! ["localhost:27017"], database: "admin"
    class Book
      include  Mongous::Document

      field  :title,        String,  :must
      field  :author,       String
      field  :publisher,    String
      field  :style,        String,  %w[hardcover softcover paperback]
      field  :size,         String,  /[AB]\d/
      field  :price,        Integer, (0..1_000_000)
      field  :page,         Integer, proc{ page > 0 }
      field  :isbn,         String,  proc{ isbn? }
      field  :lang,         String,  default: "en"
      field  :created_at,   Time,    create: proc{ Time.now }
      field  :updated_at,   Time,    update: proc{ Time.now }

      verify :strict
      verify { having?( title ) }
      verify do
        having?( author ) | having?( publisher )
      end

      def isbn?
        return  false    if isbn.nil?
        str  =  isbn.gsub(/\D*/, '')
        str.size == 13
      end
    end

    items  =  {}
    items[:_id   ]  =  Time.now.to_s
    items[:title ]  =  "verify 2"
    items[:author]  =  "jane doe"
    items[:style ]  =  "softcover"
    items[:size  ]  =  "A5"
    items[:price ]  =  2000
    items[:page  ]  =  200
    items[:isbn  ]  =  "978-3-16-148410-0"
    items[:lang  ]  =  nil
    begin
      book1  =  Book.create( **items )

      book2  =  Book.where( title: "verify 2" ).first
      expect( book2._id    ).to  eq( book1._id    )
      expect( book2.title  ).to  eq( book1.title  )
      expect( book2.author ).to  eq( book1.author )
      expect( book2.style  ).to  eq( book1.style  )
      expect( book2.size   ).to  eq( book1.size   )
      expect( book2.price  ).to  eq( book1.price  )
      expect( book2.page   ).to  eq( book1.page   )
      expect( book2.isbn   ).to  eq( book1.isbn   )
      expect( book2.lang   ).to  eq( "en"         )

    rescue => e
      p e.message

    end

    Book.delete
    Object.send( :remove_const, :Book )
  end

  it '#verify on new' do
    Mongous::connect! ["localhost:27017"], database: "admin"
    class Book
      include  Mongous::Document

      field  :title,        String,  :must
      field  :author,       String
      field  :publisher,    String
      field  :style,        String,  %w[hardcover softcover paperback]
      field  :size,         String,  /[AB]\d/
      field  :price,        Integer, (0..1_000_000)
      field  :page,         Integer, proc{ page > 0 }
      field  :isbn,         String,  proc{ isbn? }
      field  :lang,         String,  default: "en"
      field  :created_at,   Time,    create: proc{ Time.now }
      field  :updated_at,   Time,    update: proc{ Time.now }

      verify :strict
      verify { having?( title ) }
      verify do
        having?( author ) | having?( publisher )
      end

      def isbn?
        return  false    if isbn.nil?
        str  =  isbn.gsub(/\D*/, '')
        str.size == 13
      end
    end

    items  =  {}
    items[:_id   ]  =  Time.now.to_s
    items[:title ]  =  "verify 2"
    items[:author]  =  "jane doe"
    items[:style ]  =  "softcover"
    items[:size  ]  =  "A5"
    items[:price ]  =  2000
    items[:page  ]  =  200
    items[:isbn  ]  =  "978-3-16-148410-0"
    items[:lang  ]  =  nil

    begin
      book1  =  Book.new( **items )
      book1.save

      book2  =  Book.where( title: "verify 2" ).first
      expect( book2._id    ).to  eq( book1._id    )
      expect( book2.title  ).to  eq( book1.title  )
      expect( book2.author ).to  eq( book1.author )
      expect( book2.style  ).to  eq( book1.style  )
      expect( book2.size   ).to  eq( book1.size   )
      expect( book2.price  ).to  eq( book1.price  )
      expect( book2.page   ).to  eq( book1.page   )
      expect( book2.isbn   ).to  eq( book1.isbn   )
      expect( book2.lang   ).to  eq( "en"         )

    rescue => e
      p e.message

    end

    Book.delete
    Object.send( :remove_const, :Book )
  end
end

