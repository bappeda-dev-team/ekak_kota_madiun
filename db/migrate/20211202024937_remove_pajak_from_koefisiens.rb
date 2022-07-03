class RemovePajakFromKoefisiens < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :koefisiens, :pajak, :float }
  end
end
