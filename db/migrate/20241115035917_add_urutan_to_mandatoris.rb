class AddUrutanToMandatoris < ActiveRecord::Migration[6.1]
  def change
    add_column :mandatoris, :urutan, :integer, null: true
  end
end
