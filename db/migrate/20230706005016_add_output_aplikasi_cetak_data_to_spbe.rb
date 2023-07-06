class AddOutputAplikasiCetakDataToSpbe < ActiveRecord::Migration[6.1]
  def change
    add_column :spbes, :output_data, :string, null: true
    add_column :spbes, :output_informasi, :string, null: true
    add_column :spbes, :output_cetak, :string, null: true
  end
end
