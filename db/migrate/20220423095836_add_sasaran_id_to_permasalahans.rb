class AddSasaranIdToPermasalahans < ActiveRecord::Migration[6.1]
  def change
    add_column :permasalahans, :sasaran_id, :bigint, foreign: true, null: true
    add_foreign_key :permasalahans, :sasarans, column: :sasaran_id, primary_key: :id, validate: false
  end
end
