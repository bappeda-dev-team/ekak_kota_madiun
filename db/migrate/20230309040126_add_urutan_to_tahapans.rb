class AddUrutanToTahapans < ActiveRecord::Migration[6.1]
  def change
    add_column :tahapans, :urutan, :string, null: true
  end
end
