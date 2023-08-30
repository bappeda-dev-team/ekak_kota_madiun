class AddMetadataToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :metadata, :jsonb, null: true
  end
end
