RSpec.describe Mongous do
  it "has a version number" do
    expect(Mongous::VERSION).not_to be nil
  end
  it "default client has default connection." do
    expect( Mongous.client ).not_to be nil
  end
end
