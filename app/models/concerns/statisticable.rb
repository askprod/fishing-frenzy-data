module Statisticable
  extend ActiveSupport::Concern

  included do
    has_many :statistics, as: :statisticable, dependent: :destroy
    has_many :latest_statistics, -> { latest_statistics }, class_name: "Statistic", as: :statisticable

    def latest_statistic
      self.latest_statistics.last
    end

    def previous_statistic
      self.latest_statistics.last(2).first
    end

    def self.fetch_and_create_all_statistics(**args)
      self.with_nfts.map do |obj|
        obj.fetch_and_create_statistics(**args)
        obj.refresh_best_performer("floor_price")
      end
    end

    def self.refresh_best_performer(stat_name)
      return unless self.can_be_best_performer?

      performer_klass = StatisticsPerformanceAnalyzer.call(self.with_nfts, stat_name: stat_name)

      if (performer = performer_klass.best_performer) && performer_klass.best_performer_has_increased?
        self.update_all(current_best_performer: false)
        performer.update(current_best_performer: true)
      end
    end

    def fetch_and_create_statistics(**args)
      response_data = fetch_latest_skymavis_data(**args)
      adapter = self.class.skymavis_adapter_class.call(response_data)
      statistics.create(
        data: adapter.parsed_data,
        reference_date: Time.current
      )
    end

    def percentage_change_by(stat_name)
      return 0 unless self.latest_statistic.present? && self.previous_statistic.present?
      return 0 unless (latest = self.latest_statistic.data[stat_name]).present? && (previous = self.previous_statistic.data[stat_name]).present?
      return 0 if previous.zero?

      ((latest - previous) / previous * 100).round(2)
    end

    def percentage_increased?(stat_name)
      percentage_change_by(stat_name) > 0
    end
  end
end
