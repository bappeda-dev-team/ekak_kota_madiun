class AddSasaranToTahapans < ActiveRecord::Migration[6.1]
  def change
    add_reference :tahapans, :sasaran, index: true, null: true
  end
end
