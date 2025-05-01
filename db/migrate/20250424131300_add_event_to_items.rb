class AddEventToItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :items, :event, null: true, foreign_key: true, index: true
  end
end
