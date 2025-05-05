class Initializers::Leaderboards::General < Initializers::Leaderboards::Abstract
  private

  def set_category
    "general"
  end

  def fetch_data
    Apis::FishingFrenzy.call("rank", get_params: {
      "rankType": "General",
      "startPage": 1,
      "endPage": 40
    })
  end

  def parse_data
    Adapters::FishingFrenzy::Leaderboards::General.call(@data).parsed_data
  end
end
