class AddMetadataToDasarHukums < ActiveRecord::Migration[6.1]
  def change
    add_column :dasar_hukums, :metadata, :jsonb, null: true
  end
end
