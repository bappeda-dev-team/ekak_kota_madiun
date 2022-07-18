class RemoveSasaranIndikatorTargetSatuanFromKaks < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :kaks, :sasaran_kinerja, :text }
    safety_assured { remove_column :kaks, :indikator_kinerja, :text }
    safety_assured { remove_column :kaks, :target, :string }
    safety_assured { remove_column :kaks, :satuan, :string }

  end
end
