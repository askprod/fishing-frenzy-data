module DatabaseRefreshable
  extend ActiveSupport::Concern

  included do
    def self.fetch_or_refresh_records(should_create_records: false)
      # Todo: define class in each children
      self.items_initializer_class.call(should_create_records: should_create_records)
    end
  end
end
