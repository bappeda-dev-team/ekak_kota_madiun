class AddKodeTujuanToTujuanKota < ActiveRecord::Migration[6.1]
  def change
    add_column :tujuan_kota, :kode_tujuan, :string
  end
end
