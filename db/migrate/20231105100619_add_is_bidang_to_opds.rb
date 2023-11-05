class AddIsBidangToOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :is_bidang, :boolean, default: false
  end
end
