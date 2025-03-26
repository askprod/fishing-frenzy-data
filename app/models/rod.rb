class Rod < ApplicationRecord
  def self.fetch_or_refresh_records(import: true)
    Initializers::ModelInitializer.call("Rod", :rods, import: import)
  end

  def self.fetch_latest_data(create_record: true)
    response = Apis::Skymavis.call(token_address: self.token_address)
    Adapters::SkymavisToPrice.call(response).parsed_data
  end

  def self.token_address
    "0x77ce5148b7ad284e431175ad7258b54a64816da6"
  end

  def self.has_nfts?
    true
  end

  # ex. criterias: [ { name: "rarity", values: [ "legendary" ] } ]
end
