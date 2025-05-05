# == Schema Information
#
# Table name: cooking_recipe_sushis
#
#  id                :integer          not null, primary key
#  cooking_recipe_id :integer          not null
#  cooking_sushi_id  :integer          not null
#  sushi_dropchance  :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_cooking_recipe_sushis_on_cooking_recipe_id  (cooking_recipe_id)
#  index_cooking_recipe_sushis_on_cooking_sushi_id   (cooking_sushi_id)
#

class Cooking::RecipeSushi < ApplicationRecord
  belongs_to :cooking_recipe, class_name: "Cooking::Recipe", foreign_key: :cooking_recipe_id
  belongs_to :cooking_sushi, class_name: "Cooking::Sushi", foreign_key: :cooking_sushi_id

  def sushi_percent_drop_chance
    (sushi_dropchance * 100).round(2)
  end
end
