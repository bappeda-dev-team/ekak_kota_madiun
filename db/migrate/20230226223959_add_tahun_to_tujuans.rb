class AddTahunToTujuans < ActiveRecord::Migration[6.1]
  def change
    add_column :tujuans, :tahun_awal, :string, null: true
    add_column :tujuans, :tahun_akhir, :string, null: true
  end
end
