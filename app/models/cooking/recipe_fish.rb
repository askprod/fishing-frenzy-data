# == Schema Information
#
# Table name: cooking_recipe_fishes
#
#  id                :integer          not null, primary key
#  cooking_recipe_id :integer          not null
#  item_id           :integer          not null
#  fish_quantity     :integer
#  shiny_fish        :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_cooking_recipe_fishes_on_cooking_recipe_id  (cooking_recipe_id)
#  index_cooking_recipe_fishes_on_item_id            (item_id)
#

class Cooking::RecipeFish < ApplicationRecord
  # TODO: remove shiny_fish—it's already coorectly associated
  # TODO: fish_quantity ot integer—not float
  belongs_to :cooking_recipe, class_name: "Cooking::Recipe"
  belongs_to :fish, class_name: "Items::Fish", foreign_key: :item_id
end
