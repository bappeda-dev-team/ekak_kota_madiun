class AddKurunWaktuToKaksTable < ActiveRecord::Migration[6.1]
  def change
    add_column :kaks, :waktu_dibutuhkan, :text
  end
end
