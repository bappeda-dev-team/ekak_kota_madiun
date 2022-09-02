class AddPaguToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators, :pagu, :string, default: 0
  end
end
