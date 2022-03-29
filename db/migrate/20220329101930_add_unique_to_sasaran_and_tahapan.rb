class AddUniqueToSasaranAndTahapan < ActiveRecord::Migration[6.1]
  def change
    add_index :sasarans, :id_rencana, unique: true
    add_index :tahapans, :id_rencana_aksi, unique: true
  end
end
