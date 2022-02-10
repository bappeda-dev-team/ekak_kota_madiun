class AddBiayaDiperlukanToKaksTable < ActiveRecord::Migration[6.1]
  def change
    add_column :kaks, :biaya_diperlukan, :text
  end
end
