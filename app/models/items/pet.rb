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
#  active        :boolean
#  has_nft       :boolean
#
# Indexes
#
#  index_items_on_api_id         (api_id)
#  index_items_on_collection_id  (collection_id)
#  index_items_on_type           (type)
#

class Items::Pet < Item
  scope :display_order, -> { order(Arel.sql("CAST(api_data->>'quality' AS INTEGER) ASC")) }
end
