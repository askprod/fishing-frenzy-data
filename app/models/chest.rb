class Chest < ApplicationRecord
  include DatabaseRefreshable
  include Nft::Configurable
  include Nft::Statisticable

  validates :api_id, presence: true, uniqueness: true
end
