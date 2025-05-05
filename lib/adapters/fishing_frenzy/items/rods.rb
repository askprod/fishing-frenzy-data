class Adapters::FishingFrenzy::Items::Rods < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    {}.tap do |rods_data|
      @data.each do |rod_data|
        rods_data[rod_data[:id]] = {
          api_data: rod_data.except(*excluded_attributes),
          has_nft: rod_data[:isNFT],
          name: rod_data[:name],
          slug: rod_data[:name].parameterize
        }
      end
    end
  end

  def excluded_attributes
    [
      :name,
      :order,
      :userId,
      :isEquipped,
      :isPrototype,
      :isInWallet,
      :isMinted
    ]
  end
end
