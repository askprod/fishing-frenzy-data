class Adapters::Skymavis::Traits < Adapters::Skymavis::Abstract
  def parse_data
    {
      floor_price: parse_price,
      amount: @data.dig(:data, :erc721Tokens, :total) || 0
    }
  end

  def parse_price
    price = @data.dig(:data, :erc721Tokens, :results)&.first&.dig(:order, :basePrice)
    return 0 unless price
    Utilities::Calculations.wei_to_ron(price).to_f
  end
end
