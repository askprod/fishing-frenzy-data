class Adapters::Skymavis
  attr_accessor :data, :parsed_data, :price, :collection_amount

  def initialize(data)
    @data = data
    @parsed_data = parse_data
    @price = price
    @collection_amount = collection_amount
  end

  def self.call(data)
    self.new(data)
  end

  private

  def parse_data
    {
      floor_price: parse_price,
      amount: @data.dig(:data, :erc721Tokens, :total)
    }
  end

  def parse_price
    price = @data.dig(:data, :erc721Tokens, :results).first.dig(:order, :basePrice)
    Utilities::Calculations.wei_to_ron(price)
  end

  def price
    @parsed_data.dig(:floor_price)
  end

  def collection_amount
    @parsed_data.dig(:amount)
  end
end
