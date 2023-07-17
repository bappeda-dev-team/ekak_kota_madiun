class AddHasBidangToOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :has_bidang, :boolean, default: false
  end
end
