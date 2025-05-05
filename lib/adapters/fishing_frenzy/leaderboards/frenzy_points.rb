class Adapters::FishingFrenzy::Leaderboards::FrenzyPoints < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    {}.tap do |hash|
      hash[:type] = :frenzy_points
      hash[:title] = data[:title]
      hash[:end_date] = Utilities::Other.round_time((Time.current + data[:remainSeconds]), 60)
      hash[:leaderboard] = {}
      data.dig(:results).each do |results|
        hash[:leaderboard][results.dig(:userId)] = {
          rank: results.dig(:currentRank),
          multiplier: results.dig(:multiplier),
          points: results.dig(:points)
        }
      end
    end
  end
end
