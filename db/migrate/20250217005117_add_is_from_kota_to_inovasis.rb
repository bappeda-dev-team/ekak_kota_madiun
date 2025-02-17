class AddIsFromKotaToInovasis < ActiveRecord::Migration[6.1]
  def change
    add_column :inovasis, :is_from_kota, :boolean, default: false
  end
end
