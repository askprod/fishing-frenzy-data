# == Schema Information
#
# Table name: items
#
#  id            :integer          not null, primary key
#  name          :string
#  slug          :string
#  type          :string
#  collection_id :integer          not null
#  api_id        :string
#  api_data      :jsonb
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  has_nft       :boolean
#  event_id      :integer
#
# Indexes
#
#  index_items_on_api_id         (api_id)
#  index_items_on_collection_id  (collection_id)
#  index_items_on_event_id       (event_id)
#  index_items_on_type           (type)
#

class Items::Chest < Item
  # TODO: display order, by hand or add rarity?

  def floor_price
    return 0 unless latest_statistic&.data.present?

    latest_statistic.data.dig("floor_price")
  end

  def listed_amount
    return 0 unless latest_statistic&.data.present?

    latest_statistic.data.dig("amount")
  end
end
