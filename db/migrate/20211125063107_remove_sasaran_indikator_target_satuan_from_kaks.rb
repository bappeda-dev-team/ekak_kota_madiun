class RemoveSasaranIndikatorTargetSatuanFromKaks < ActiveRecord::Migration[6.1]
  def change
    remove_column :kaks, :sasaran_kinerja, :text
    remove_column :kaks, :indikator_kinerja, :text
    remove_column :kaks, :target, :string
    remove_column :kaks, :satuan, :string

  end
end
