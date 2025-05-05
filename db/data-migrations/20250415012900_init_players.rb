leaderboard_adapter = Adapters::FishingFrenzy::Leaderboard.call(max_page: 40)
leaderboard_data = leaderboard_adapter.parsed_data

# Use the players fetched to init a bunch of players for now
leaderboard_data.each do |player_id, ranking_data|
  next if Player.exists?(api_id: player_id)

  player = Player.create(api_id: player_id)
  player.refresh_player_data
  player.player_ranks.create(api_data: ranking_data) # deprecated
  sleep(0.8)
end;nil

Player.refresh_global_leaderboard_ranks # deprecated
