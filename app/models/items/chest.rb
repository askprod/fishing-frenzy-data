# == Schema Information
#
# Table name: items
#
#  id                     :integer          not null, primary key
#  name                   :string
#  slug                   :string
#  type                   :string
#  collection_id          :integer          not null
#  api_id                 :string
#  api_data               :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  has_nft                :boolean
#  event_id               :integer
#  current_best_performer :boolean
#
# Indexes
#
#  index_items_on_api_id         (api_id)
#  index_items_on_collection_id  (collection_id)
#  index_items_on_event_id       (event_id)
#  index_items_on_type           (type)
#

class Items::Chest < Item
  RARITIES = [ "Common", "Rare", "Epic", "Legendary" ].freeze
  SERIES = [ "Origins", "Sushi", "Golden", "Pioneer" ].freeze

  has_many :chest_loots, class_name: "Chest::Loot", foreign_key: :chest_id, dependent: :destroy, inverse_of: :chest
  has_many :consumables, through: :chest_loots

  scope :display_order, -> { order(Arel.sql("has_nft ASC, CAST(api_data->>'quality' AS INTEGER) ASC")) }

  def self.can_be_best_performer?
    true
  end

  def floor_price
    return 0 unless latest_statistic&.data.present?

    latest_statistic.data.dig("floor_price")
  end

  def listed_amount
    return 0 unless latest_statistic&.data.present?

    latest_statistic.data.dig("amount")
  end

  def marketplace_link
    return unless has_nft? && marketplace_params.present?

    "https://marketplace.roninchain.com/collections/fishing-frenzy-chests?#{marketplace_params}"
  end


  def marketplace_params
    rarity = RARITIES.find { |r| type.include?(r) }
    series = SERIES.find { |s| type.include?(s) }

    params = {}
    params["Rarity"] = rarity if rarity
    params["Series"] = series if series

    URI.encode_www_form(params)
  end

  def simplified_loot_items
    return {} if loot_items.blank?

    loot_items.flatten.map do |loot_item|
      {
        type: loot_item["type"],
        drop_rate: loot_item["dropRate"],
        quantity: loot_item["quantity"],
        api_id: loot_item["itemId"]
      }
    end
  end
end
