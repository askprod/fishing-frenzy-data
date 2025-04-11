class Initializers::ModelInitializer
  attr_reader :data

  def initialize(class_name, type, import: false)
    @data = []
    @type = type
    @model_klass = class_name.safe_constantize
  end

  def self.call(class_name, type, import: false)
    puts class_name
    puts type
    _self = self.new(class_name, type, import: import)
    _self.fetch_all_data
    _self.import_data if import
    _self
  end

  def fetch_all_data
    first_page = Apis::FishingFrenzy.call(@type)
    total_results = first_page.dig(:totalResults).to_i
    full_data = Apis::FishingFrenzy.call(@type, get_params: { limit: total_results })
    @data.concat(full_data.dig(:results))
  end

  def import_data
    @data.each do |hash|
      next if @model_klass.exists?(api_id: hash.dig(:id))
      @model_klass.create(api_data: hash.except(:id), api_id: hash.dig(:id))
    end
  end
end
