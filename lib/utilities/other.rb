class Utilities::Other
  def self.shorten_eth_address(address)
    return address unless address.is_a?(String) && address.length > 10
    "#{address[0..3]}...#{address[-4..]}"
  end

  def self.floor_time(time_obj, seconds)
    Time.at((time_obj.to_f / seconds).floor * seconds).utc
  end

  def self.round_time(time_obj, seconds)
    Time.at((time_obj.to_f / seconds).round * seconds).utc
  end
end
