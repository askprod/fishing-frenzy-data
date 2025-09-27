class Adapters::FishingFrenzy::Items::Consumables < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    {}.tap do |consumables_data|
      @data[:results].each do |consumable_data|
        consumables_data[consumable_data[:id]] = {
          api_data: consumable_data.except(*excluded_attributes),
          name: consumable_data[:name],
          slug: consumable_data[:name].parameterize
        }
      end
    end
  end

  def excluded_attributes
    %i[
      id
      __v
      purchaseLimit
      quantity
      order
      isBuyInShop
    ]
  end
end
