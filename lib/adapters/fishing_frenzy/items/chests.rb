class Adapters::FishingFrenzy::Items::Chests < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    {}.tap do |chests_data|
      @data.each do |chest_data|
        chests_data[chest_data[:id]] = {
          api_data: chest_data.except(*excluded_attributes),
          has_nft: !non_nft_ids.include?(chest_data[:id]),
          name: chest_data[:name],
          slug: chest_data[:name].parameterize
        }
      end
    end
  end

  def excluded_attributes
    %i[
      id
      name
      price
      description
      image
      percentValue
      isStarterPack
      isPremium
    ]
  end

  def non_nft_ids
    [
      "66da652977fbb86eacd09fb4", # Participation Chest
      "67d5899abccee2e00b399df0" # Starter Chest
    ]
  end
end
