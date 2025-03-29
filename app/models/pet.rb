class Pet < ApplicationRecord
  include DatabaseRefreshable

  validates :api_id, presence: true, uniqueness: true

  scope :display_order, -> { order(Arel.sql("CAST(api_data->>'quality' AS INTEGER) ASC")) }
end
