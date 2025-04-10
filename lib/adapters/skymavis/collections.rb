class Adapters::Skymavis::Collections < Adapters::Skymavis::Abstract
  def parse_data
    {
      volume: @data.dig(:data, :tokenData, :volumeAllTime).round || 0,
      owners: @data.dig(:data, :tokenData, :totalOwners) || 0,
      items: @data.dig(:data, :tokenData, :totalItems) || 0,
      listings: @data.dig(:data, :tokenData, :totalListing) || 0,
      floor_price: parse_price
    }
  end

  def parse_price
    price = @data.dig(:data, :tokenData, :minPrice)
    return 0 unless price
    Utilities::Calculations.wei_to_ron(price).to_f
  end
end
