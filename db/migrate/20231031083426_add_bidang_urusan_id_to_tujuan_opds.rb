class AddBidangUrusanIdToTujuanOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :tujuans, :bidang_urusan_id, :bigint, null: true
  end
end
