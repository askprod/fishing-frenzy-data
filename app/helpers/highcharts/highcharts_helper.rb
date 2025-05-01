module Highcharts::HighchartsHelper
  def highcharts_formatted_nft_data(statistics)
    statistics.map do |stat|
      {
        amount: stat.data["amount"],
        floor_price: stat.data["floor_price"],
        date: stat.reference_date.to_time.to_i * 1000
      }
    end.to_json
  end
end
