class Apis::Skymavis::Web3::AccountNfts < Apis::Skymavis::Web3::Abstract
  def initialize(address:)
    @requested_address = address
    @path = "accounts/#{@requested_address}/nfts"
  end
end
