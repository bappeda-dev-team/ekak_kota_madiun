class AddMetadataToSpbeRincians < ActiveRecord::Migration[6.1]
  def change
    add_column :spbe_rincians, :metadata, :jsonb, null: true
  end
end
