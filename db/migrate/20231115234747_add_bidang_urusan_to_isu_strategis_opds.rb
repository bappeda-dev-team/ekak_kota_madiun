class AddBidangUrusanToIsuStrategisOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :isu_strategis_opds, :bidang_urusan, :string, null: true
  end
end
