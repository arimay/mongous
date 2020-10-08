RSpec.describe Mongous do
  it "has a version number" do
    expect(Mongous::VERSION).not_to be nil
  end
  it "default client is nil" do
    expect( Mongous.client ).to be nil
  end
end
