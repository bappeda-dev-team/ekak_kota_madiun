class AddTahunToAnggarans < ActiveRecord::Migration[6.1]
  def change
    add_column :anggarans, :tahun, :integer, null: true
  end
end
