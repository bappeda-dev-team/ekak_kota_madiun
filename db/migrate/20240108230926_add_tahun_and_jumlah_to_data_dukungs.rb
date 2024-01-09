class AddTahunAndJumlahToDataDukungs < ActiveRecord::Migration[6.1]
  def change
    add_column :data_dukungs, :tahun, :string
    add_column :data_dukungs, :jumlah, :integer
    add_column :data_dukungs, :satuan, :string
  end
end
