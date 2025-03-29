module DatabaseRefreshable
  extend ActiveSupport::Concern

  included do
    def self.fetch_or_refresh_records(import: true)
      Initializers::ModelInitializer.call(self.name, self.name.pluralize.to_sym, import: import)
    end
  end
end
