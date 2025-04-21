class CreatePlayersMetrics < ActiveRecord::Migration[8.0]
  def change
    create_table :players_metrics do |t|
      t.jsonb :api_data
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
