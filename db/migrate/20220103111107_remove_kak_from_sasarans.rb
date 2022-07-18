class RemoveKakFromSasarans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    remove_index :sasarans, name: :index_sasarans_on_kak_id, algorithm: :concurrently
  end
end
