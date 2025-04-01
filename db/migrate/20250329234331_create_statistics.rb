class CreateStatistics < ActiveRecord::Migration[8.0]
  def change
    create_table :statistics do |t|
      t.references :statisticable, polymorphic: true, null: false
      t.jsonb :data

      t.timestamps
    end
  end
end
