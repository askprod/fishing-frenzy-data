class Adapters::FishingFrenzy::Items::Chests < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    {}.tap do |chests_data|
      @data.each do |chest_data|
        chests_data[chest_data[:id]] = {
          api_data: chest_data.except(*excluded_attributes),
          has_nft: chest_data[:isNFT],
          name: chest_data[:name],
          slug: chest_data[:name].parameterize
        }
      end
    end
  end

  def excluded_attributes
    %i[
      _id
      name
      description
      isMinted
      isPrototype
      items
      createdAt
      updatedAt
      __v
      order
      isNFT
      openable
      id
    ]
  end
end
