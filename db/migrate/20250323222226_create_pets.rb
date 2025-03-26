class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.jsonb :api_data
      t.string :api_id

      t.timestamps
    end
  end
end
