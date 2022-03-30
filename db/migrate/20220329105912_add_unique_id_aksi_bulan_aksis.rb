class AddUniqueIdAksiBulanAksis < ActiveRecord::Migration[6.1]
  def change
    add_index :aksis, :id_aksi_bulan, unique: true
  end
end
