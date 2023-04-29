class AddKeteranganInIndikatorSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :indikator_sasarans, :keterangan, :string
  end
end
