class AddUraianTagToInovasis < ActiveRecord::Migration[6.1]
  def change
    add_column :inovasis, :uraian_tag, :string
  end
end
