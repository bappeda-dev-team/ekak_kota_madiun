class AddKeteranganToRencanaAksiOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :rencana_aksi_opds, :keterangan, :string
  end
end
