class Chest < ApplicationRecord
  def self.fetch_or_refresh_records(import: true)
    Initializers::ModelInitializer.call("Pet", :pets, import: import)
  end

  def self.token_address
    "0x9c76fc5bd894e7f51c422f072675c876d5998a9e"
  end

  def self.has_nfts?
    true
  end
end
