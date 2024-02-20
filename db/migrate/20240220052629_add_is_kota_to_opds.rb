class AddIsKotaToOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :is_kota, :boolean, default: false
  end
end
