class RemoveActiveFromItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :items, :active, :boolean
  end
end
