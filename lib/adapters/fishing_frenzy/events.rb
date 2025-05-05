class Adapters::FishingFrenzy::Events < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    events_data = {}

    @data.each do |event_data|
      events_data[event_data[:id]] = {
        name: event_data[:name],
        description: event_data[:description],
        active: event_data[:active],
        end_date: (Time.parse(event_data[:endDate]) rescue nil),
        default_theme_id: event_data[:themes].find { |t| t[:name].include? event_data[:name] }[:id],
        pet_ids: event_data[:pets].map { |f| f[:id] }
      }
    end

    events_data.each do |event_id, event_data|
      puts event_data
      theme_data = Apis::FishingFrenzy.call("events_switch_theme", path_params: {
        eventId: event_id,
        themeId: event_data[:default_theme_id]
      })

      events_data[event_id][:fish_ids] = theme_data[:listFish]&.map { |f| f[:id] }
    end

    events_data
  end
end
