class RemovePajakFromKoefisiens < ActiveRecord::Migration[6.1]
  def change
    remove_column :koefisiens, :pajak, :float
  end
end
