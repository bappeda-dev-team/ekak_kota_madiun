class AddTahunToKepegawaians < ActiveRecord::Migration[6.1]
  def change
    add_column :kepegawaians, :tahun, :string, null: false
  end
end
