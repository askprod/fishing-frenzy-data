class Fish < ApplicationRecord
  include DatabaseRefreshable

  validates :api_id, presence: true, uniqueness: true

  scope :non_shiny, -> { where("api_data ->> 'isShinyFish' = 'false'") }
  scope :display_order, -> { order(Arel.sql("CAST(api_data->>'quality' AS INTEGER) ASC, CAST(api_data->>'sellPrice' AS INTEGER) ASC")) }
end
