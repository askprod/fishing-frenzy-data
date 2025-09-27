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

class Items::Pet < Item
  scope :display_order, -> { order(Arel.sql("CAST(api_data->>'quality' AS INTEGER) ASC")) }
  scope :with_event, -> { where.not(event_id: nil) }
  scope :event_ongoing, -> { joins(:event).merge(Event.ongoing) }
  scope :by_rarity, ->(int) {
    where("api_data ->> 'quality' = ?", int)
  }

  def min_catch_fish
    api_data.dig("catchFish", "min")
  end

  def max_catch_fish
    api_data.dig("catchFish", "max")
  end

  # TODO: Create association table
  def fish_drop_rate
    api_data.dig("catchFish", "dropRate")&.sort_by { |item| item["rate"] }&.reverse
  end

  def fish_percent_chance(fish_id)
    fish_drop_rate.find { |d| d["fishId"].eql? fish_id }["rate"]
  end
end
