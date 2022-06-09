class AddTahunToPerhitungan < ActiveRecord::Migration[6.1]
  def change
    add_column :perhitungans, :tahun, :string, null: true
  end
end
