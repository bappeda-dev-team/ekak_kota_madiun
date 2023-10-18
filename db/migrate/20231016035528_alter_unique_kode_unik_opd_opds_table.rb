class AlterUniqueKodeUnikOpdOpdsTable < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :opds, %i[kode_unik_opd lembaga_id], unique: true, algorithm: :concurrently
    remove_index :opds, :kode_unik_opd, algorithm: :concurrently
  end
end
