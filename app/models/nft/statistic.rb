class Nft::Statistic < ApplicationRecord
  validates :nft_type, presence: true
  validates :trait, presence: true

  # TODO: Callback that sends data to the correct wss channel to update in views
end
