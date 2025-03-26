class Fish < ApplicationRecord
  scope :non_shiny, -> { where("api_data ->> 'isShinyFish' = 'false'") }
  scope :display_order, -> { order(Arel.sql("CAST(api_data->>'quality' AS INTEGER) ASC, CAST(api_data->>'sellPrice' AS INTEGER) ASC")) }

  def self.fetch_or_refresh_records(import: true)
    Initializers::ModelInitializer.call("Fish", :fish, import: import)
  end

  def self.token_address
    ""
  end

  def self.has_nfts?
    true
  end
end
