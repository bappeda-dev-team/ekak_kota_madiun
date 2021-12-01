class RemoveKoefisienFromPerhitungans < ActiveRecord::Migration[6.1]
  def change
    remove_column :perhitungans, :koefisien, :string
  end
end
