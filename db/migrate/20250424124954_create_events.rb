class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.boolean :active
      t.string :description
      t.datetime :end_date
      t.string :api_id
      t.string :name
      t.string :default_theme_id
      t.string :slug

      t.timestamps
    end
  end
end
