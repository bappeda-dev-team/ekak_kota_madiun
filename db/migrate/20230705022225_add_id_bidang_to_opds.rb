class AddIdBidangToOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :id_bidang, :integer, null: true
  end
end
