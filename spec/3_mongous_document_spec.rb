
RSpec.describe "Mongous::Document: save document." do
  it '#new(), #save' do
    Mongous::connect! ["localhost:27017"], database: "admin"
    class Book
      include Mongous::Document
    end

    book1  =  Book.new
    expect( book1.class ).to  eq( Book )
    book1._id  =  Time.new.to_s
    book1.title  =  "book1"
    book1.save
    book2  =  Book.where( title: "book1" ).first
    expect( book2._id ).to  eq( book1._id )

    Book.delete
    Object.send( :remove_const, :Book )
  end

  it '#new( **items ), #save' do
    Mongous::connect! ["localhost:27017"], database: "admin"
    class Book
      include Mongous::Document
    end

    book1  =  Book.new( _id: Time.new.to_s, title: "book2" )
    expect( book1.class ).to  eq( Book )
    book1.save
    book2  =  Book.where( title: "book2" ).first
    expect( book2._id ).to  eq( book1._id )

    Book.delete
    Object.send( :remove_const, :Book )
  end

  it '#create( **items )' do
    Mongous::connect! ["localhost:27017"], database: "admin"
    class Book
      include Mongous::Document
    end

    book1  =  Book.create( _id: Time.new.to_s, title: "book3" )
    expect( book1.class ).to  eq( Book )
    book2  =  Book.where( title: "book3" ).first
    expect( book2._id ).to  eq( book1._id )

    Book.delete
    Object.send( :remove_const, :Book )
  end
end

