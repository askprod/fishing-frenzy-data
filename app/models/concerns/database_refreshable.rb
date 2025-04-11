module DatabaseRefreshable
  extend ActiveSupport::Concern

  included do
    def self.fetch_or_refresh_records(import: true)
      Initializers::ModelInitializer.call(
        self.to_s,
        self.to_s.demodulize.downcase.pluralize.to_sym,
        import: import
      )
    end
  end
end
