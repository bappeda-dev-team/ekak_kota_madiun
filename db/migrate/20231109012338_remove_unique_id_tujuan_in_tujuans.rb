class RemoveUniqueIdTujuanInTujuans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    remove_index :tujuans, column: :id_tujuan, algorithm: :concurrently
  end
end
