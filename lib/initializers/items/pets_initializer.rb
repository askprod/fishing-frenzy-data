class Initializers::Items::PetsInitializer
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
    first_page = Apis::FishingFrenzy.call("pets")
    total_results = first_page.dig(:totalResults).to_i
    full_data = Apis::FishingFrenzy.call("pets", get_params: { limit: total_results })
    full_data.dig(:results)
  end

  def create_records
    collection = Collection.find_by(name: "Pet")

    @data.each do |hash|
      pet = collection.pet_items.find_or_initialize_by(api_id: hash[:id])
      pet.assign_attributes(
        api_id: hash[:id],
        api_data: hash.except(:id),
        name: hash[:name],
        slug: hash[:name].parameterize,
        collection: collection,
        has_nft: false
      )
      pet.save!
    end
  end
end
