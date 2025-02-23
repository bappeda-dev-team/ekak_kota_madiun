class AddIsBagianToOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :is_bagian, :boolean, default: false
  end
end
