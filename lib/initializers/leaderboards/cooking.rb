class Initializers::Leaderboards::Cooking < Initializers::Leaderboards::Abstract
  private

  def set_category
    "cooking"
  end

  def fetch_data
    Apis::FishingFrenzy.call("rank", get_params: {
      "rankType": "Cooking",
      "startPage": 1,
      "endPage": 40
    })
  end

  def parse_data
    Adapters::FishingFrenzy::Leaderboards::Cooking.call(@data).parsed_data
  end
end
