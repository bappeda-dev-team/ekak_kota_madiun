class AddMetadataToTahapans < ActiveRecord::Migration[6.1]
  def change
    add_column :tahapans, :metadata, :jsonb, null: true
  end
end
