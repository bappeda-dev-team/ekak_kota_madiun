class AddUniqueToIdKamusKamusUsulans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :kamus_usulans, :id_kamus, unique: true, algorithm: :concurrently
  end
end
