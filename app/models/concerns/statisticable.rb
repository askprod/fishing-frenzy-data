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
      statistics.create(data: adapter.parsed_data)
    end

    def latest_statistic
      # TOD: might need to base date on another columns than created_at at some point
      statistics.order(created_at: :asc).last
    end

    def previous_statistic
      statistics.order(created_at: :asc).last(2)&.first
    end
  end
end
