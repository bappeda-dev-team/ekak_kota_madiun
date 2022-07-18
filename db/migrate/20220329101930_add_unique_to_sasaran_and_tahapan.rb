class AddUniqueToSasaranAndTahapan < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :sasarans, :id_rencana, unique: true, algorithm: :concurrently
    add_index :tahapans, :id_rencana_aksi, unique: true, algorithm: :concurrently
  end
end
