class AddUrutanToMandatoris < ActiveRecord::Migration[6.1]
  def change
    add_column :mandatoris, :urutan, :integer, default: 1, null: false
  end
end
