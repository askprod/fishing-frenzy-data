
class Initializers::Leaderboards::FrenzyPoints < Initializers::Leaderboards::Abstract
  private

  def set_category
    "frenzy_points"
  end

  def fetch_data
    Apis::FishingFrenzy.call("rank", get_params: {
      "rankType": "Frenzy_point",
      "startPage": 1,
      "endPage": 40
    })
  end

  def parse_data
    Adapters::FishingFrenzy::Leaderboards::FrenzyPoints.call(@data).parsed_data
  end
end
