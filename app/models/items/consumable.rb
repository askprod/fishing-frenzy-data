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

class Items::Consumable < Item
  has_many :chest_loots, class_name: "Chest::Loot", foreign_key: :consumable_id, dependent: :destroy, inverse_of: :consumable
end
