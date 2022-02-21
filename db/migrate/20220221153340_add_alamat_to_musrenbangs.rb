class AddAlamatToMusrenbangs < ActiveRecord::Migration[6.1]
  def change
    add_column :musrenbangs, :alamat, :text, null: true
  end
end
