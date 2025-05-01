module StatisticsHelper
  def human_stat_name(name)
    {
      amount: "Amount Listed",
      floor_price: "Floor Price",
      volume: "Volume",
      items: "Amount Listed",
      owners: "Owners",
      listings: "Listings"
    }[name.to_sym]
  end

  def percentage_suffix(percentage)
    return "" if percentage.zero?
    percentage.positive? ? "+" : ""
  end

  def percentage_color(percentage)
    return "text-green-400" if percentage.positive?
    return "text-red-400" if percentage.negative?
    "text-gray-400"
  end
end
