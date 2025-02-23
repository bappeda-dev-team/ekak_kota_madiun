class AddTagActiveToInovasis < ActiveRecord::Migration[6.1]
  def change
    add_column :inovasis, :tag_active, :boolean, default: false
  end
end
