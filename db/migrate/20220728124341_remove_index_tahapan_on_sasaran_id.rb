class RemoveIndexTahapanOnSasaranId < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    remove_index :aksis, name: :index_aksis_on_tahapan_id, algorithm: :concurrently
  end
end
