class AddKeteranganInIsuStrategisKotum < ActiveRecord::Migration[6.1]
  def change
    add_column :isu_strategis_kota, :keterangan, :string
    add_column :strategi_kota, :keterangan, :string
    add_column :isu_strategis_opds, :keterangan, :string
    add_column :strategi_opds, :keterangan, :string
  end
end
