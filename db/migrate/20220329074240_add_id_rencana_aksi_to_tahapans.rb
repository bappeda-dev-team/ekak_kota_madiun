class AddIdRencanaAksiToTahapans < ActiveRecord::Migration[6.1]
  def change
    add_column :tahapans, :id_rencana_aksi, :string, null: true
    add_column :tahapans, :id_rencana, :string, null: true
  end
end
