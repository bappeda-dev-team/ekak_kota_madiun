class AddMasterUrusanIdToTujuans < ActiveRecord::Migration[6.1]
  def change
    add_column :tujuans, :urusan_id, :bigint, null: true
  end
end
