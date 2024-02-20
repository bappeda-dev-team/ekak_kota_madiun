class AddTahunAsetToAsets < ActiveRecord::Migration[6.1]
  def change
    add_column :asets, :tahun_aset, :string, array: true
  end
end
