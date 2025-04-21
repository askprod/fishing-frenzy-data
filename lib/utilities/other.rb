class Utilities::Other
  def self.shorten_eth_address(address)
    return address unless address.is_a?(String) && address.length > 10
    "#{address[0..3]}...#{address[-4..]}"
  end
end
