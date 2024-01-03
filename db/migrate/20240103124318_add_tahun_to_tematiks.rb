class AddTahunToTematiks < ActiveRecord::Migration[6.1]
  def change
    add_column :tematiks, :tahun, :string, null: true
  end
end
