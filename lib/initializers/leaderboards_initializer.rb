class Initializers::LeaderboardsInitializer
  attr_reader :parsed_data, :should_create_records

  def initialize(should_create_records: false)
    @adapter = Adapters::FishingFrenzy::Leaderboard.call(max_page: 40)
    @parsed_data = @adapter.parsed_data
    @should_create_records = should_create_records
  end

  def self.call(should_create_records: false)
    _self = self.new(should_create_records: should_create_records)
    _self.create_records if _self.should_create_records
  end

  def create_records
    @parsed_data.each do |leaderboard_data|
      leaderboard = upsert_leaderboard(leaderboard_data)
      leaderboard_refresh = leaderboard.leaderboard_refreshes.build

      leaderboard_data[:leaderboard].each do |player_id, rank_data|
        player = upsert_player(player_id)
        create_rank(leaderboard_refresh, player, rank_data)
      end

      leaderboard_refresh.refreshed_at = Time.current
      leaderboard_refresh.save!
    end

    update_global_leaderboard_ranks
  end

  def upsert_leaderboard(leaderboard_data)
    if (ongoing_leaderboard = Leaderboard.send("category_#{leaderboard_data[:type]}").ongoing).any?
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

  def update_global_leaderboard_ranks
    global_leaderboard = if (lb = Leaderboard.find_by(category: :global)).present?
      lb
    else
      Leaderboard.create(category: :global, end_date: Time.current + 10.years)
    end

    leaderboard_refresh = global_leaderboard.leaderboard_refreshes.build

    global_leaderboard_data = Utilities::GlobalLeaderboardRanker.call(
      Player.with_rank.map { |player| [ player.api_id, player.ranks.latest ] }.to_h
    )

    global_leaderboard_data.each do |player_id, player_rank|
      player = Player.find_by(api_id: player_id)
      create_rank(leaderboard_refresh, player, { rank: player_rank })
    end

    leaderboard_refresh.refreshed_at = Time.current
    leaderboard_refresh.save!
  end
end
