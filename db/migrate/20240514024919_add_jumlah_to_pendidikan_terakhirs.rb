class AddJumlahToPendidikanTerakhirs < ActiveRecord::Migration[6.1]
  def change
    add_column :pendidikan_terakhirs, :jumlah, :integer
  end
end
