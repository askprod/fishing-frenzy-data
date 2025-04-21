class CreatePlayersRanks < ActiveRecord::Migration[8.0]
  def change
    create_table :players_ranks do |t|
      t.jsonb :api_data
      t.integer :global_calculated_rank
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
