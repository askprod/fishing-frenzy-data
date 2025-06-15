class Utilities::WalletValueCalculator
  attr_reader :api_data, :wallet_value, :fish

  def initialize(address)
    @requested_address = address
    @api_data = get_account_data
    @items = @api_data.dig(:result, :items)
    @fish = get_account_fish
    @rods = get_account_rods
    @chests = get_account_chests
    calculate_value
  end

  def self.call(address)
    self.new(address)
  end

  private

  def get_account_data
    Apis::Skymavis::Web3::AccountNfts.call(address: @requested_address)
  end

  def get_account_fish
    fish_nfts = @items.select { |i| i[:symbol].eql? "FRENZYFISH" }
    fish_nfts.blank? ? Items::Fish.none : fish_nfts

    {}.tap do |hash|
      fish_nfts.each do |fish|
        name = fish.dig(:metadata, :name)
        hash.key?(name) ? hash[name] += 1 : hash[name] = 1
      end
    end
  end

  def get_account_chests
  end

  def get_account_rods
  end

  def calculate_value
    @wallet_value = {}.tap do |hash|
      hash[:fish_value] = calculate_fish_value
      hash[:rods_value] = calculate_rods_value
      hash[:chests_value] = calculate_chests_value
    end

    @wallet_value[:total_value] = calculate_total_value
    @wallet_value
  end

  def calculate_fish_value
    @fish.map do |name, amount|
      (Items::Fish.find_by(name: name)&.floor_price || 0) * amount
    end.sum
  end

  def calculate_rods_value
    0
  end

  def calculate_chests_value
    0
  end

  def calculate_total_value
    @wallet_value[:fish_value] + @wallet_value[:rods_value] + @wallet_value[:chests_value]
  end
end
