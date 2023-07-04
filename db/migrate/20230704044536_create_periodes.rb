class CreatePeriodes < ActiveRecord::Migration[6.1]
  def change
    create_table :periodes do |t|
      t.string :tahun_awal
      t.string :tahun_akhir

      t.timestamps
    end
  end
end
