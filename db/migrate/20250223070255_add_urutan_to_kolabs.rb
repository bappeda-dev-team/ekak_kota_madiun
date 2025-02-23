class AddUrutanToKolabs < ActiveRecord::Migration[6.1]
  def change
    add_column :kolabs, :urutan, :integer, default: 0
  end
end
