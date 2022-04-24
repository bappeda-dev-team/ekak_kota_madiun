class AddSasaranIdToLatarBelakangs < ActiveRecord::Migration[6.1]
  def change
    add_column :latar_belakangs, :sasaran_id, :bigint, foreign_key: true, null: true
    add_foreign_key :latar_belakangs, :sasarans, column: :sasaran_id, primary_key: :id, validate: false
  end
end
