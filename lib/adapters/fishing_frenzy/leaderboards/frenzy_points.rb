class Adapters::FishingFrenzy::Leaderboards::FrenzyPoints < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    {}.tap do |hash|
      data.dig(:results).each do |results|
        hash[results.dig(:userId)]= {}
        hash[results.dig(:userId)][:frenzy_points] = {
          rank: results.dig(:currentRank),
          multiplier: results.dig(:multiplier),
          points: results.dig(:points)
        }
      end
    end
  end
end
