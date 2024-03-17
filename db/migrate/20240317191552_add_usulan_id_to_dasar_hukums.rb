class AddUsulanIdToDasarHukums < ActiveRecord::Migration[6.1]
  def change
    add_column :dasar_hukums, :usulan_id, :bigint, null: true
  end
end
