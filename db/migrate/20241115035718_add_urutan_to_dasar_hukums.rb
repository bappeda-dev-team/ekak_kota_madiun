class AddUrutanToDasarHukums < ActiveRecord::Migration[6.1]
  def change
    add_column :dasar_hukums, :urutan, :integer, null: true
  end
end
