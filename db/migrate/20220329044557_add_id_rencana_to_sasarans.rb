class AddIdRencanaToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :id_rencana, :string, null: true
  end
end
