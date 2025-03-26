class CreateRods < ActiveRecord::Migration[8.0]
  def change
    create_table :rods do |t|
      t.string :api_id
      t.jsonb :api_data

      t.timestamps
    end
  end
end
