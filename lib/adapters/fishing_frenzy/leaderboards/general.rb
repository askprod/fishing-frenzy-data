class Adapters::FishingFrenzy::Leaderboards::General < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    {}.tap do |hash|
      hash[:type] = :general
      hash[:title] = data[:title]
      hash[:end_date] = Utilities::Other.round_time((Time.current + data[:remainSeconds]), 60)
      hash[:leaderboard] = {}
      data.dig(:leaderBoard, :results).each do |results|
        hash[:leaderboard][results[:id]] = {
          rank: results.dig(:currentRank),
          tier_name: results.dig(:tier),
          points: results.dig(:points)
        }
      end
    end
  end
end
