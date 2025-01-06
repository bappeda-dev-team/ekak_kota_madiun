class AddIsHiddenToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators, :is_hidden, :boolean, null: false, default: false
  end
end
