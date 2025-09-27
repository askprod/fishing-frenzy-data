class StatisticsPerformanceAnalyzer
  attr_reader :collection, :stat_name, :results

  def initialize(collection, stat_name: "floor_price")
    @collection = collection.includes(:statistics)
    @stat_name = stat_name
  end

  def self.call(collection, stat_name: "floor_price")
    _self = self.new(collection, stat_name: stat_name)
    _self.call
    _self
  end

  def best_performer
    @results.first
  end

  def best_performer_has_increased?
    return false if best_performer.blank?

    best_performer[:change_percentage] > 0
  end

  def call
    @results = @collection.map do |item|
      latest_stat = item.latest_statistic&.data&.dig(@stat_name).to_f
      previous_stat = item.previous_statistic&.data&.dig(@stat_name).to_f

      next if latest_stat.zero? || previous_stat.zero?

      {
        item: item,
        "latest_#{@stat_name}": latest_stat,
        "previous_#{@stat_name}": previous_stat,
        change_percentage: calculate_change(previous_stat, latest_stat)
      }
    end.compact.sort_by { |res| -res[:change_percentage] }
  end

  private

  def calculate_change(previous_stat, latest_stat)
    return 0 if previous_stat.zero?

    ((latest_stat - previous_stat) / previous_stat * 100).round(2)
  end
end
