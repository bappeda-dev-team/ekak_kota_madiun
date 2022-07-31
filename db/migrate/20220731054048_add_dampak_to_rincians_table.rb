class AddDampakToRinciansTable < ActiveRecord::Migration[6.1]
  def change
    add_column :rincians, :dampak, :string, null: true
  end
end
