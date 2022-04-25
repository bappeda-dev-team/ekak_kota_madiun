class AddUniqueIdIndikatorIndikatorkinerjas < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :indikator_sasarans, :id_indikator, unique: true, algorithm: :concurrently
  end
end
