class AddSetInputToRekenings < ActiveRecord::Migration[6.1]
  def change
    add_column :rekenings, :set_input, :integer, default: 0
  end
end
