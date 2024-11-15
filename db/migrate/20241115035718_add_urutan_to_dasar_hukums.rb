class AddUrutanToDasarHukums < ActiveRecord::Migration[6.1]
  def change
    add_column :dasar_hukums, :urutan, :integer, default: 1, null: false
  end
end
