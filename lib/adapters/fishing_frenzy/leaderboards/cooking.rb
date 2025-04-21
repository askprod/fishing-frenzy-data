class Adapters::FishingFrenzy::Leaderboards::Cooking < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    {}.tap do |hash|
      data.dig(:leaderBoard, :results).each do |results|
        hash[results[:id]] = {}
        hash[results[:id]][:cooking] = {
          rank: results.dig(:currentRank),
          tier: results.dig(:tier),
          points: results.dig(:points)
        }
      end
    end
  end
end
