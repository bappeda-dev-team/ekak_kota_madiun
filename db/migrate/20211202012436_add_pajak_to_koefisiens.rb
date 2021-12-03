class AddPajakToKoefisiens < ActiveRecord::Migration[6.1]
  def change
    add_column :koefisiens, :pajak, :float, :default => 0
  end
end
