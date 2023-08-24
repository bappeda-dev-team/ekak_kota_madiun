class AddStatusMetadataToPohons < ActiveRecord::Migration[6.1]
  def change
    add_column :pohons, :status, :string, null: true
    add_column :pohons, :metadata, :jsonb, null: true
  end
end
