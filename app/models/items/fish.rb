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
#  event_id      :integer
#
# Indexes
#
#  index_items_on_api_id         (api_id)
#  index_items_on_collection_id  (collection_id)
#  index_items_on_event_id       (event_id)
#  index_items_on_type           (type)
#

class Items::Fish < Item
  has_many :cooking_recipe_fishes, class_name: "Cooking::RecipeFish", foreign_key: :item_id, dependent: :destroy
  has_many :cooking_recipes, through: :cooking_recipe_fishes

  scope :display_order, -> { order(Arel.sql("CAST(api_data->>'quality' AS INTEGER) ASC, CAST(api_data->>'sellPrice' AS INTEGER) ASC")) }

  before_validation :define_default_attributes

  def floor_price
    return 0 unless latest_statistic&.data.present?

    latest_statistic.data.dig("floor_price")
  end

  def listed_amount
    return 0 unless latest_statistic&.data.present?

    latest_statistic.data.dig("amount")
  end

  def catch_difficulty_percentage
    difficulty_values = Items::Fish.all.map(&:difficulty_rate)
    lowest_percentage, highest_percentage = 5, 100
    min, max = difficulty_values.minmax
    return lowest_percentage if min == max

    (((difficulty_rate - min).to_f / (max - min) * (highest_percentage - lowest_percentage)) + lowest_percentage).round
  end

  def marketplace_link
    return unless has_nft?

    "https://marketplace.roninchain.com/collections/fishing-frenzy-fish?Name=#{CGI.escape(name)}"
  end

  private

  def define_default_attributes
    # TODO active will not be a column on fish (to delete later), it should rely on if a Event is active or not
    self.active = false if active.nil?
  end
end
