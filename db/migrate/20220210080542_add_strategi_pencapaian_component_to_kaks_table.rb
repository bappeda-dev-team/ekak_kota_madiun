class AddStrategiPencapaianComponentToKaksTable < ActiveRecord::Migration[6.1]
  def change
    add_column :kaks, :metode_pelaksanaan, :text
    add_column :kaks, :tahapan_pelaksanaan, :text
  end
end
