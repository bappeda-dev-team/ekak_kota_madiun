class AddTahunToPermasalahans < ActiveRecord::Migration[6.1]
  def change
    add_column :permasalahans, :tahun, :string, null: true
  end
end
