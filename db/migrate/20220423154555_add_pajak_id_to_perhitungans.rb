class AddPajakIdToPerhitungans < ActiveRecord::Migration[6.1]
  def change
    add_column :perhitungans, :pajak_id, :bigint, foreign: true, null: true
    add_foreign_key :perhitungans, :pajaks, column: :pajak_id, primary_key: :id, on_delete: :nullify, validate: false
  end
end
