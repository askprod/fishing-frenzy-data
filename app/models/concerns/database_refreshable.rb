module DatabaseRefreshable
  extend ActiveSupport::Concern

  included do
    def self.fetch_and_refresh_records(should_create_records: false)
      # TODO define class in each children
      self.items_initializer_class.call(should_create_records: should_create_records)
    end
  end
end
