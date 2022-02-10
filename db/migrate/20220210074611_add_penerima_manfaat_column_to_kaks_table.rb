class AddPenerimaManfaatColumnToKaksTable < ActiveRecord::Migration[6.1]
  def change
    add_column :kaks, :penerima_manfaat, :text
    remove_column :kaks, :tujuan, :text
  end
end
