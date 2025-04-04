class Items::Fish < Item
  scope :display_order, -> { order(Arel.sql("CAST(api_data->>'quality' AS INTEGER) ASC, CAST(api_data->>'sellPrice' AS INTEGER) ASC")) }

  def floor_price
    latest_statistic.data.dig("floor_price")
  end

  def listed_amount
    latest_statistic.data.dig("amount")
  end

  def catch_difficulty_percentage
    difficulty_values = Items::Fish.all.map(&:difficulty_rate)
    lowest_percentage, highest_percentage = 5, 100
    min, max = difficulty_values.minmax
    return lowest_percentage if min == max

    (((difficulty_rate - min).to_f / (max - min) * (highest_percentage - lowest_percentage)) + lowest_percentage).round
  end
end
