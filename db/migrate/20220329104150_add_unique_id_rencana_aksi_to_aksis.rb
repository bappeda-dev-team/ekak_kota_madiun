class AddUniqueIdRencanaAksiToAksis < ActiveRecord::Migration[6.1]
  def change
    add_column :aksis, :id_rencana_aksi, :string
    add_column :aksis, :id_aksi_bulan, :string, unique: true
  end
end
