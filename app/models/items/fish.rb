class Items::Fish < Item
  scope :display_order, -> { order(Arel.sql("CAST(api_data->>'quality' AS INTEGER) ASC, CAST(api_data->>'sellPrice' AS INTEGER) ASC")) }

  def floor_price
    latest_statistic.data.dig("floor_price")
  end

  def listed_amount
    latest_statistic.data.dig("amount")
  end
end
