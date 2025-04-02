class Items::Chest < Item
  # TODO: display order, by hand or add rarity?

  def floor_price
    latest_statistic.data.dig("floor_price")
  end

  def listed_amount
    latest_statistic.data.dig("amount")
  end
end
