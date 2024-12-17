class AddTerpilihToAkarMasalahs < ActiveRecord::Migration[6.1]
  def change
    add_column :akar_masalahs, :terpilih, :boolean
  end
end
