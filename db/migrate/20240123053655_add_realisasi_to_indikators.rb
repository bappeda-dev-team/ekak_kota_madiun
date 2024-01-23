class AddRealisasiToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators, :realisasi, :string, null: true
  end
end
