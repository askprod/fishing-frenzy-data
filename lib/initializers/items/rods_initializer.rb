class Initializers::Items::RodsInitializer
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
    response = Apis::FishingFrenzy.call("rods", get_params: { isPrototype: true,  limit: 100 })
    response[:results]
  end

  def create_records
    collection = Collection.find_by(name: "Rod")
    adapter = Adapters::FishingFrenzy::Items::Rods.call(@data)

    adapter.parsed_data.each do |rod_id, rod_data|
      if collection.rod_items.exists?(api_id: rod_id)
        collection.rod_items.find_by(api_id: rod_id).update_columns(rod_data.except(:api_id))
      else
        collection.rod_items.create({ api_id: rod_id }.merge(rod_data))
      end
    end
  end
end
