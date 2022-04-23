class CreatePermasalahans < ActiveRecord::Migration[6.1]
  def change
    create_table :permasalahans do |t|
      t.text :permasalahan
      t.text :jenis
      t.string :penyebab_internal
      t.string :penyebab_external

      t.timestamps
    end
  end
end
