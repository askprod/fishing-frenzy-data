module Statisticable
  extend ActiveSupport::Concern

  included do
    has_many :statistics, as: :statisticable

    def self.fetch_and_create_all_statistics(**args)
      self.with_nfts.map { |obj| obj.fetch_and_create_statistics(**args) }
    end

    def fetch_and_create_statistics(**args)
      response_data = fetch_latest_skymavis_data(**args)
      adapter = self.class.skymavis_adapter_class.call(response_data)
      statistics.create(
        data: adapter.parsed_data,
        reference_date: Time.current
      )
    end

    def latest_statistic
      statistics.latest_statistic.presence || nil
    end

    def previous_statistic
      statistics.previous_statistic.presence || nil
    end
  end
end
