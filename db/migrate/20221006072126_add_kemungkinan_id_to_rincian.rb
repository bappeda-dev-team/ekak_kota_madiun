class AddKemungkinanIdToRincian < ActiveRecord::Migration[6.1]
  def change
    add_column :rincians, :kemungkinan_id, :integer, null: true, index: true
  end
end
