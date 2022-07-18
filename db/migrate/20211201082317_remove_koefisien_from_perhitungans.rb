class RemoveKoefisienFromPerhitungans < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :perhitungans, :koefisien, :string }
  end
end
