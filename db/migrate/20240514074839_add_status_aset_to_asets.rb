class AddStatusAsetToAsets < ActiveRecord::Migration[6.1]
  def change
    add_column :asets, :status_aset, :jsonb, null: true, default: '{}'
  end
end
