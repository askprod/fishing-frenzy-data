class Utilities::StatisticsAggregator
  attr_reader :percentage_changes

  TIME_FRAMES = {
    "6h": 6.hours.ago,
    "1d": 1.day.ago,
    "7d": 7.days.ago
  }

  DEFAULT_ORDER = {
    "amount" => 5,
    "floor_price" => 10,
    "volume" => 20,
    "items" => 30,
    "owners" => 40,
    "listings" => 50
  }

  def initialize(statistics)
    @statistics = statistics
  end

  def self.call(statistics)
    new(statistics).percentage_changes
  end

  def percentage_changes
    changes_by_timeframe = TIME_FRAMES.transform_values do |time_threshold|
      earlier_stat = @statistics
        .select { |stat| stat.reference_date <= time_threshold }
        .max_by { |stat| stat.reference_date }

      later_stat = @statistics
        .select { |stat| stat.reference_date >= time_threshold }
        .max_by(&:reference_date)

      if earlier_stat.nil? || later_stat.nil? || earlier_stat == later_stat
        # Build a hash with all known stat keys and default 0
        default_keys = @statistics.flat_map { |s| s.data.keys }.uniq
        default_keys.index_with { 0 }
      else
        calculate_percentage_change(earlier_stat.data, later_stat.data)
      end
    end

    changes_by_stat = {}

    changes_by_timeframe.each do |timeframe, changes|
      changes.each do |stat_name, change|
        changes_by_stat[stat_name] ||= {}
        changes_by_stat[stat_name][timeframe] = change
      end
    end

    # Ensure all stats have all timeframes filled with 0 if missing
    changes_by_stat.each do |stat_name, tf_changes|
      TIME_FRAMES.keys.each do |tf|
        tf_changes[tf] ||= 0
      end
    end

    @percentage_changes = sort_by_default_order(changes_by_stat)
  end


  private

  def calculate_percentage_change(earlier_data, later_data)
    earlier_data.each_with_object({}) do |(key, old_value), result|
      old_val = old_value.to_f
      new_val = later_data[key].to_f

      result[key] = old_val.zero? ? nil : Utilities::Calculations.smart_round((((new_val - old_val) / old_val) * 100))
    end
  end

  def sort_by_default_order(changes_by_stat)
    changes_by_stat.sort_by do |stat_name, _|
      DEFAULT_ORDER.fetch(stat_name, Float::INFINITY)
    end.to_h
  end
end
