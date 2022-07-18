class RemoveIndexFromSasarans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    remove_index :sasarans, name: "index_sasarans_on_program_kegiatan_id", algorithm: :concurrently
  end
end
