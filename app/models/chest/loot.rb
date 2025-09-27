# == Schema Information
#
# Table name: chest_loots
#
#  id            :integer          not null, primary key
#  chest_id      :integer          not null
#  consumable_id :integer
#  loot_type     :integer
#  quantity      :integer
#  drop_chance   :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_chest_loots_on_chest_id       (chest_id)
#  index_chest_loots_on_consumable_id  (consumable_id)
#

class Chest::Loot < ApplicationRecord
  belongs_to :chest, class_name: "Items::Chest", foreign_key: :chest_id, inverse_of: :chest_loots
  belongs_to :consumable, class_name: "Items::Consumable", foreign_key: :consumable_id, optional: true, inverse_of: :chest_loots

  enum :loot_type, { consumable: 0, gold: 1 }
end
