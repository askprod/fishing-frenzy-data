class AddReferenceDateToStatistics < ActiveRecord::Migration[8.0]
  def change
    add_column :statistics, :reference_date, :datetime
  end
end
