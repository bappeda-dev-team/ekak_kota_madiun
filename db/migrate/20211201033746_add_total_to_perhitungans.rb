class AddTotalToPerhitungans < ActiveRecord::Migration[6.1]
  def change
    add_column :perhitungans, :total, :integer
  end
end
