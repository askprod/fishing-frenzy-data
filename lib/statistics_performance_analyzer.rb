class StatisticsPerformanceAnalyzer
  attr_reader :collection, :stat_name, :results

  def initialize(collection, stat_name: "floor_price")
    @collection = collection
    @stat_name = stat_name.to_s
  end

  def self.call(collection, stat_name: "floor_price")
    instance = new(collection, stat_name: stat_name)
    instance.call
    instance
  end

  def best_performer
    @results.first
  end

  def call
    @results = @collection.preload(:statistics).map do |item|
      period, change = item.stats_percentage_change_by(@stat_name).max_by { |_, v| v.abs } || [ nil, 0 ]

      {
        item: item,
        change: change,
        period: period
      }
    end.sort_by { |res| -res[:change].abs }
  end
end
