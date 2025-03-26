class Pet < ApplicationRecord
  scope :display_order, -> { order(Arel.sql("CAST(api_data->>'quality' AS INTEGER) ASC")) }

  def self.fetch_or_refresh_records(import: true)
    Initializers::ModelInitializer.call("Pet", :pets, import: import)
  end

  def self.has_nfts?
    false
  end
end
