class AddIsPerintahWalikotaToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :is_perintah_walikota, :boolean, default: false
  end
end
