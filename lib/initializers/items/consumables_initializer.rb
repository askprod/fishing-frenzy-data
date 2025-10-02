class Initializers::Items::ConsumablesInitializer
  attr_reader :data, :should_create_records

  def initialize(should_create_records: false)
    @data = fetch_all_data
    @should_create_records = should_create_records
  end

  def self.call(should_create_records: false)
    _self = self.new(should_create_records: should_create_records)
    _self.create_records if _self.should_create_records
  end

  def fetch_all_data
    first_page = Apis::FishingFrenzy.call("items")
    total_results = first_page.dig(:totalResults).to_i
    results = Apis::FishingFrenzy.call("items", get_params: { limit: total_results })

    extra_records_ids.each do |extra_record_id|
      results[:results] << Apis::FishingFrenzy.call("items/#{extra_record_id}")
    end

    results
  end

  def create_records
    collection = Collection.find_by(name: "Consumables")
    adapter = Adapters::FishingFrenzy::Items::Consumables.call(@data)

    adapter.parsed_data.each do |consumable_id, consumable_data|
      if collection.consumable_items.exists?(api_id: consumable_id)
        collection.consumable_items
          .find_by(api_id: consumable_id)
          .update_columns(consumable_data.except(:api_id))
      else
        collection.consumable_items
          .create({ api_id: consumable_id }
          .merge(consumable_data))
      end
    end
  end

  def extra_records_ids
    [ "688a26cf2ea7512215bab23e" ]
  end
end
