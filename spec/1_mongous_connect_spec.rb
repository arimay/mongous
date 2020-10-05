
RSpec.describe "Mongous::connect" do
  it 'before' do
    expect( Mongous.client.class ).to  eq( NilClass )
  end

  it 'connect' do
    client = Mongous::connect
    expect( client.class ).to  eq( Mongo::Client )
    expect( client.database.name ).to  eq( "test" )
  end

  it 'connect by url' do
    client = Mongous::connect "mongodb://localhost:27017/url"
    expect( client.class ).to  eq( Mongo::Client )
    expect( client.database.name ).to  eq( "url" )
  end

  it "connect by yml" do
    filepath = File.join( File.dirname(__FILE__), File.basename(__FILE__, ".rb") + ".yml" )
    client = Mongous::connect( file: filepath )
    expect( client.class ).to  eq( Mongo::Client )
    expect( client.database.name ).to  eq( "yml" )
  end

  it 'Book1' do
    class Book1
      include Mongous::Document
      self.client  =  Mongous::connect
    end
    expect( Book1.client.class ).to  eq( Mongo::Client )
    expect( Book1.client.database.name ).to  eq( "test" )
    expect( Book1.collection.class ).to  eq( Mongo::Collection )
    expect( Book1.collection_name ).to  eq( Book1.name )
    Object.send( :remove_const, :Book1 )
  end

  it 'connect!' do
    Mongous::connect!
    expect( Mongous.client.class ).to  eq( Mongo::Client )
    expect( Mongous.client.database.name ).to  eq( "test" )
  end

  it 'Book2' do
    class Book2
      include Mongous::Document
    end
    expect( Book2.client.class ).to  eq( Mongo::Client )
    expect( Book2.client.database.name ).to  eq( "test" )
    expect( Book2.collection.class ).to  eq( Mongo::Collection )
    expect( Book2.collection_name ).to  eq( Book2.name )
    Object.send( :remove_const, :Book2 )
  end

  it 'Book3' do
    class Book3
      include Mongous::Document
      self.collection_name  =  "FooBar"
    end
    expect( Book3.client.class ).to  eq( Mongo::Client )
    expect( Book3.client.database.name ).to  eq( "test" )
    expect( Book3.collection.class ).to  eq( Mongo::Collection )
    expect( Book3.collection_name ).to  eq( "FooBar" )
    Object.send( :remove_const, :Book3 )
  end
end

