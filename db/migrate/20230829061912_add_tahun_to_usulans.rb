class AddTahunToUsulans < ActiveRecord::Migration[6.1]
  def change
    add_column :usulans, :tahun, :string, null: true
  end
end
