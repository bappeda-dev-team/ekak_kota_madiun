class AddTagToInovasis < ActiveRecord::Migration[6.1]
  def change
    add_column :inovasis, :tag, :string
  end
end
