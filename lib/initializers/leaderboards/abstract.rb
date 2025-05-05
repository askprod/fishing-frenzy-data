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

class Initializers::Leaderboards::Abstract
  attr_reader :data, :parsed_data, :should_create_records

  def initialize(should_create_records: false)
    @should_create_records = should_create_records
    @category = set_category

    @data = fetch_data
    @parsed_data = parse_data
  end

  def self.call(should_create_records: false)
    _self = self.new(should_create_records: should_create_records)
    _self.create_records if _self.should_create_records
  end

  def create_records
    leaderboard = upsert_leaderboard(@parsed_data)
    leaderboard_refresh = leaderboard.leaderboard_refreshes.build

    @parsed_data[:leaderboard].each do |player_id, rank_data|
      player = upsert_player(player_id)
      create_rank(leaderboard_refresh, player, rank_data)
    end

    leaderboard_refresh.refreshed_at = Time.current
    leaderboard_refresh.save!
  end

  private

  def category
    nil
  end

  def fetch_data
    {}
  end

  def parse_data
    {}
  end

  def upsert_leaderboard(leaderboard_data)
    if (ongoing_leaderboard = Leaderboard.send("category_#{@category}").ongoing).any?
      ongoing_leaderboard.first
    else
      Leaderboard.create(
        category: leaderboard_data[:type],
        end_date: leaderboard_data[:end_date],
        title: leaderboard_data[:title]
      )
    end
  end

  def upsert_player(player_id)
    if Player.exists?(api_id: player_id)
      Player.find_by(api_id: player_id)
    else
      Player.create_player(player_id)
    end
  end

  def create_rank(leaderboard_refresh, player, rank_data)
    Rank.create(
      { player: player, leaderboard_refresh: leaderboard_refresh }.merge(rank_data)
    )
  end

  def clear_records
    Rank.destroy_all
    LeaderboardRefresh.destroy_all
    Leaderboard.destroy_all
  end
end
