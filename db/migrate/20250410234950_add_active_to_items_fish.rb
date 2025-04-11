class AddActiveToItemsFish < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :active, :boolean
  end
end
