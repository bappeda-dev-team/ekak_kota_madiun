class AddOpdIdToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :opd_id, :bigint, null: true
  end
end
