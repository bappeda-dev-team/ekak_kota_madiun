class AddPohonRefIdToPohons < ActiveRecord::Migration[6.1]
  def change
    add_column :pohons, :pohon_ref_id, :bigint, null: true
  end
end
