class AddUniqueToKodeUnikOpdOpds < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :opds, :kode_unik_opd, unique: true, algorithm: :concurrently
  end
end
