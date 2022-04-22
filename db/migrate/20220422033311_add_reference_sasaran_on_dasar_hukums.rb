class AddReferenceSasaranOnDasarHukums < ActiveRecord::Migration[6.1]
  def change
    add_column :dasar_hukums, :sasaran_id, :string
    add_foreign_key :dasar_hukums, :sasarans, column: :sasaran_id, primary_key: :id_rencana, validate: false
  end
end
