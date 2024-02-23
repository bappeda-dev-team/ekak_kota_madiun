class AddBarangIdToPerhitungans < ActiveRecord::Migration[6.1]
  def change
    add_column :perhitungans, :barang_id, :bigint, null: true
  end
end
