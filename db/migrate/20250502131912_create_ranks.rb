class CreateRanks < ActiveRecord::Migration[8.0]
  def change
    create_table :ranks do |t|
      t.references :player, foreign_key: true
      t.references :leaderboard, foreign_key: true

      t.string :tier_name
      t.integer :rank
      t.integer :points
      t.float :multiplier

      t.timestamps
    end
  end
end
