
RSpec.describe "Mongous::Document: declare document." do
  it 'minimal declaration.' do
    Mongous::attach!  :Book1
    Mongous::attach!  :Book2, :Book3

    expect( Book1.collection_name ).to  eq( Book1.name )
    expect( Book2.collection_name ).to  eq( Book2.name )
    expect( Book3.collection_name ).to  eq( Book3.name )

    Object.send( :remove_const, :Book1 )
    Object.send( :remove_const, :Book2 )
    Object.send( :remove_const, :Book3 )
  end

  it 'set class.name to collection_name.' do
    Mongous::connect! ["localhost:27017"], database: "admin"
    class Book1
      include  Mongous::Document
    end
    class Book2
      include  Mongous::Document
    end

    expect( Book1.collection_name ).to  eq( Book1.name )
    expect( Book2.collection_name ).to  eq( Book2.name )

    Object.send( :remove_const, :Book1 )
    Object.send( :remove_const, :Book2 )
  end
end

