module ApiDataAccessible
  extend ActiveSupport::Concern

  included do
    after_initialize :define_api_data_methods
  end

  private

  def define_api_data_methods
    api_data.keys.map(&:underscore).each do |key|
      self.class.define_method(key) do
        api_data[key.camelize(:lower)]
      end
    end
  end
end
