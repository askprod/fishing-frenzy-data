class Adapters::FishingFrenzy::Leaderboards::General < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    {}.tap do |hash|
      data.dig(:leaderBoard, :results).each do |results|
        hash[results[:id]] = {}
        hash[results[:id]][:fishing] = {
          rank: results.dig(:currentRank),
          tier: results.dig(:tier),
          points: results.dig(:points)
        }
      end
    end
  end
end
