class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :api_id
      t.string :slug
      t.string :search_keywords
      t.datetime :last_automatic_api_refresh_at
      t.datetime :last_manual_api_refresh_at

      t.timestamps
    end
  end
end
