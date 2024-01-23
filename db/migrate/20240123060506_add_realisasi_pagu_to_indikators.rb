class AddRealisasiPaguToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators, :realisasi_pagu, :string, null: true
  end
end
