class AddKotakToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators, :kotak, :integer, null: false, default: 0
  end
end
