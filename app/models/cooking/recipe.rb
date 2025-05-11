# == Schema Information
#
# Table name: cooking_recipes
#
#  id         :integer          not null, primary key
#  api_data   :jsonb
#  api_id     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#  event_id   :integer
#  available  :boolean
#
# Indexes
#
#  index_cooking_recipes_on_event_id  (event_id)
#

class Cooking::Recipe < ApplicationRecord
  include ApiDataAccessible

  belongs_to :event, optional: true

  has_many :cooking_recipe_sushis, class_name: "Cooking::RecipeSushi", foreign_key: :cooking_recipe_id, dependent: :destroy
  has_many :sushis, through: :cooking_recipe_sushis, class_name: "Cooking::Sushi"

  has_many :cooking_recipe_fishes, class_name: "Cooking::RecipeFish", foreign_key: :cooking_recipe_id, dependent: :destroy
  has_many :fish, through: :cooking_recipe_fishes, class_name: "Items::Fish", source: :fish

  before_validation :define_slug

  scope :available, -> { where(available: true) }
  scope :with_event, -> { where.not(event_id: nil) }
  scope :without_event, -> { where(event_id: nil) }
  scope :special, -> {
    joins(:fish)
      .group("cooking_recipes.id")
      .having("COUNT(CASE WHEN items.has_nft = TRUE THEN 1 END) > 0")
  }
  scope :not_special, -> {
    left_joins(:fish)
      .group("cooking_recipes.id")
      .having("COUNT(CASE WHEN items.has_nft = TRUE THEN 1 END) = 0")
  }
  scope :display_order, lambda {
    joins(:fish)
      .group("cooking_recipes.id")
      .order(Arel.sql(<<~SQL.squish))
        COUNT(CASE WHEN items.has_nft THEN 1 END) ASC,
        COUNT(items.id) ASC,
        cooking_recipes.slug ASC
      SQL
  }

  def current_ron_price
    return unless has_shiny_fish?

    cooking_recipe_fishes.map do |recipe_fish|
      recipe_fish.fish_quantity * recipe_fish.fish.floor_price
    end.sum.round(3)
  end

  def has_shiny_fish?
    cooking_recipe_fishes.map(&:fish).map(&:has_nft).any?
  end

  def calculated_ffdb_value
    # TODO
  end

  private

  def define_slug
    self.slug = name.parameterize if slug.nil?
  end
end
