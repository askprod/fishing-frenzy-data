class Initializers::EventsInitializer
  attr_reader :api_data, :parsed_data, :should_create_records

  def initialize(should_create_records: false)
    @api_data = Apis::FishingFrenzy.call("events_active")
    @parsed_data = Adapters::FishingFrenzy::Events.call(@api_data).parsed_data
    @should_create_records = should_create_records
  end

  def self.call(should_create_records: false)
    _self = self.new(should_create_records: should_create_records)
    _self.create_records if _self.should_create_records
  end

  def create_records
    @parsed_data.each do |event_id, event_attributes|
      event = if Event.exists?(api_id: event_id)
        Event.find_by(api_id: event_id)
      else
        attributes = event_attributes.except(*excluded_event_attributes)
        attributes[:api_id] = event_id
        attributes[:slug] = event_attributes[:name].parameterize
        Event.create(**attributes)
      end

      Items::Pet.where(api_id: event_attributes[:pet_ids]).update_all(
        active: true,
        event_id: event.id
      )

      Items::Fish.where(api_id: event_attributes[:fish_ids]).update_all(
        active: true,
        event_id: event.id
      )
    end
  end

  def excluded_event_attributes
    %i[fish_ids pet_ids]
  end
end
