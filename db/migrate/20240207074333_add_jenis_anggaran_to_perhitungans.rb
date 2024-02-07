class AddJenisAnggaranToPerhitungans < ActiveRecord::Migration[6.1]
  def change
    add_column :perhitungans, :jenis_anggaran, :string, null: true
  end
end
