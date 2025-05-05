class CreateLeaderboardRefreshes < ActiveRecord::Migration[8.0]
  def change
    create_table :leaderboard_refreshes do |t|
      t.datetime :refreshed_at
      t.references :leaderboard, foreign_key: true

      t.timestamps
    end

    add_reference :ranks, :leaderboard_refresh, foreign_key: true
    remove_reference :ranks, :leaderboard, foreign_key: true
    remove_column :leaderboards, :last_refresh_at, :datetime
  end
end
