# To get leaderboards info, make request to rank_type with type:
# This returns in (:leaderboard, :fishing, :results)
# All the Tiers with the totalItems, which is the number of players per tier until the next one
# ex.
# type=General will return
# data.dig(:leaderboard, :fishing, :results).map {|tier| tier.except(:users)}
# [{:tier=>"Angler", :tierName=>"Angler", :currentPage=>1, :limit=>50, :totalItem=>20, :totalPages=>1},
#  {:tier=>"Pro", :tierName=>"Pro", :currentPage=>1, :limit=>50, :totalItem=>80, :totalPages=>2},
#  {:tier=>"Elite", :tierName=>"Elite", :currentPage=>1, :limit=>50, :totalItem=>220, :totalPages=>5},
#  {:tier=>"Apprentice", :tierName=>"Apprentice", :currentPage=>1, :limit=>50, :totalItem=>480, :totalPages=>10},
#  {:tier=>"Deck_hands", :tierName=>"Deck Hands", :currentPage=>1, :limit=>50, :totalItem=>1200, :totalPages=>24}]
#
# Since you can't pass limit in get param - we need to calculate the number of pages to get the full results on each tier
# ex. Deck_hand - totalItems = 1200, 50 per page so 1200/50 = 24
# Now make request to rank with startPage: 1, endPage: 24
# And get all the players from rank Deck_hand
#
# Also notice that full results = 20+80+220+480+1200 = 2000
# So any endpoint on rank will only ever return 2000 max results (max 40 pages)

class Adapters::FishingFrenzy::Leaderboard
  attr_reader :fishing_data,
              :cooking_data,
              :frenzy_points_data,
              :parsed_fishing_data,
              :parsed_cooking_data,
              :parsed_frenzy_points_data,
              :parsed_data

  def initialize(max_page: 1)
    @max_page = (max_page > 40) ? 40 : max_page

    fetch_fishing_data
    fetch_cooking_data
    fetch_frenzy_points_data

    @parsed_data = parse_data
  end

  def self.call(max_page: 1)
    _self = self.new(max_page: max_page)
    _self
  end

  private

  def fetch_fishing_data
    fetched_data = Apis::FishingFrenzy.call("rank", get_params: {
      "rankType": "General",
      "startPage": 1,
      "endPage": @max_page
    })

    adapter = Adapters::FishingFrenzy::Leaderboards::General.call(fetched_data)
    @fishing_data = fetched_data
    @parsed_fishing_data = adapter.parsed_data
  end

  def fetch_cooking_data
    fetched_data = Apis::FishingFrenzy.call("rank", get_params: {
      "rankType": "Cooking",
      "startPage": 1,
      "endPage": @max_page
    })

    adapter = Adapters::FishingFrenzy::Leaderboards::Cooking.call(fetched_data)
    @cooking_data = fetched_data
    @parsed_cooking_data = adapter.parsed_data
  end

  def fetch_frenzy_points_data
    fetched_data = Apis::FishingFrenzy.call("rank", get_params: {
      "rankType": "Frenzy_point",
      "startPage": 1,
      "endPage": @max_page
    })

    adapter = Adapters::FishingFrenzy::Leaderboards::FrenzyPoints.call(fetched_data)
    @frenzy_points_data = fetched_data
    @parsed_frenzy_points_data = adapter.parsed_data
  end

  def parse_data
    [ @parsed_fishing_data, @parsed_cooking_data, @parsed_frenzy_points_data ]
  end
end
