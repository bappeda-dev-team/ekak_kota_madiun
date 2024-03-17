class AddUsulanIdToPermasalahans < ActiveRecord::Migration[6.1]
  def change
    add_column :permasalahans, :usulan_id, :bigint, null: true
  end
end
