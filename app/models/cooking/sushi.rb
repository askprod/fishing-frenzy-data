# == Schema Information
#
# Table name: cooking_sushis
#
#  id         :integer          not null, primary key
#  name       :string
#  api_data   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#

class Cooking::Sushi < ApplicationRecord
  include ApiDataAccessible

  validates :name, presence: true, uniqueness: true

  has_many :cooking_recipe_sushis, class_name: "Cooking::RecipeSushi", foreign_key: :cooking_sushi_id
  has_many :cooking_recipes, through: :cooking_recipe_sushis

  before_validation :define_slug

  private

  def define_slug
    self.slug = name.parameterize if slug.nil?
  end
end
