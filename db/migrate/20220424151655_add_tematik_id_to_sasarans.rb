class AddTematikIdToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :subkegiatan_tematik_id, :bigint, foreign_key: true, null: true
    add_foreign_key :sasarans, :subkegiatan_tematiks, column: :subkegiatan_tematik_id, primary_key: :id, validate: false
  end
end
