class AddKodeBidangUrusanToIsuStrategisOpd < ActiveRecord::Migration[6.1]
  def change
    add_column :isu_strategis_opds, :kode_bidang_urusan, :string, null: true
  end
end
