class AddKeteranganToSasaran < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :keterangan, :string, null: true
  end
end
