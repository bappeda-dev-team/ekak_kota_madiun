class AddUniqueIdAksiBulanAksis < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :aksis, :id_aksi_bulan, unique: true, algorithm: :concurrently
  end
end
