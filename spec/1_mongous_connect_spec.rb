
RSpec.describe "Mongous::connect" do
  it 'connect (default)' do
    client = Mongous::connect
    expect( client.class ).to  eq( Mongo::Client )
    expect( client.database.name ).to  eq( "test" )
  end

  it 'connect (url)' do
    client = Mongous::connect "mongodb://localhost:27017/url"
    expect( client.class ).to  eq( Mongo::Client )
    expect( client.database.name ).to  eq( "url" )
  end

  it 'connect (yml)' do
    filepath = File.join( File.dirname(__FILE__), File.basename(__FILE__, ".rb") + ".yml" )
    client = Mongous::connect( file: filepath )
    expect( client.class ).to  eq( Mongo::Client )
    expect( client.database.name ).to  eq( "yml" )
  end

  it 'connect (details)' do
    client = Mongous::connect ["localhost:27017"], database: "admin"
    expect( client.class ).to  eq( Mongo::Client )
    expect( client.database.name ).to  eq( "admin" )
  end

  it 'self.client=' do
    class Book
      include Mongous::Document
      self.client  =  Mongous::connect
    end
    expect( Book.client.class ).to  eq( Mongo::Client )
    expect( Book.client.database.name ).to  eq( "test" )
    expect( Book.collection.class ).to  eq( Mongo::Collection )
    expect( Book.collection_name ).to  eq( Book.name )

    Object.send( :remove_const, :Book )
  end

  it 'connect!' do
    Mongous::connect!
    expect( Mongous.client.class ).to  eq( Mongo::Client )
    expect( Mongous.client.database.name ).to  eq( "test" )
  end

  it 'self.collection_name' do
    class Book
      include Mongous::Document
    end
    expect( Book.client.class ).to  eq( Mongo::Client )
    expect( Book.client.database.name ).to  eq( "test" )
    expect( Book.collection.class ).to  eq( Mongo::Collection )
    expect( Book.collection_name ).to  eq( Book.name )

    Object.send( :remove_const, :Book )
  end

  it 'self.collection_name=' do
    class Book
      include Mongous::Document
      self.collection_name  =  "FooBar"
    end
    expect( Book.client.class ).to  eq( Mongo::Client )
    expect( Book.client.database.name ).to  eq( "test" )
    expect( Book.collection.class ).to  eq( Mongo::Collection )
    expect( Book.collection_name ).to  eq( "FooBar" )

    Object.send( :remove_const, :Book )
  end
end

