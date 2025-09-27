class Initializers::Leaderboards::Aquarium < Initializers::Leaderboards::Abstract
  private

  def set_category
    "aquarium"
  end

  def fetch_data
    Apis::FishingFrenzy.call("rank", get_params: {
      "rankType": "Aquarium",
      "startPage": 1,
      "endPage": 40,
      "limit": 100000
    })
  end

  def parse_data
    Adapters::FishingFrenzy::Leaderboards::Aquarium.call(@data).parsed_data
  end
end
