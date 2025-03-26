class CreateFish < ActiveRecord::Migration[8.0]
  def change
    create_table :fish do |t|
      t.jsonb :api_data, default: {}
      t.string :api_id
      t.timestamps
    end
  end
end
