class AddOutputaplikasiTerintegrasidenganToSpbes < ActiveRecord::Migration[6.1]
  def change
    add_column :spbes, :output_aplikasi, :string
    add_column :spbes, :terintegrasi_dengan, :string
  end
end
