class CreateLeaderboards < ActiveRecord::Migration[8.0]
  def change
    create_table :leaderboards do |t|
      t.datetime :end_date
      t.integer :category
      t.datetime :last_refresh_at
      t.string :title
      t.string :subtitle

      t.timestamps
    end
  end
end
