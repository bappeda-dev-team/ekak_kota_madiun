class AddKeteranganToDasarHukums < ActiveRecord::Migration[6.1]
  def change
    add_column :dasar_hukums, :keterangan, :string, null: true
  end
end
