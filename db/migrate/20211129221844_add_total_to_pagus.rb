class AddTotalToPagus < ActiveRecord::Migration[6.1]
  def change
    add_column :pagus, :total, :integer
  end
end
