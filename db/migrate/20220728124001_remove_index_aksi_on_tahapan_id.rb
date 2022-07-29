class RemoveIndexAksiOnTahapanId < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    remove_index :tahapans, name: :index_tahapans_on_sasaran_id, algorithm: :concurrently
  end
end
