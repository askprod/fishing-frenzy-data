class StatisticsPerformanceAnalyzer
  attr_reader :collection, :stat_name, :results

  def initialize(collection, stat_name: "floor_price")
    @collection = collection# .preload(:latest_statistics)
    @stat_name = stat_name
  end

  def self.call(collection, stat_name: "floor_price")
    _self = self.new(collection, stat_name: stat_name)
    _self.call
    _self
  end

  def best_performer
    @results.first[:item]
  end

  def best_performer_has_increased?
    return false if @results.empty?

    @results.first[:change] > 0
  end

  def call
    @results = @collection.map do | i|
      { item: i, change: i.percentage_change_by(@stat_name) }
    end.sort_by { |res| -res[:change] }
  end
end
