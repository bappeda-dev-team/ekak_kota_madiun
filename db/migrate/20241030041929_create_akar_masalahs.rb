class CreateAkarMasalahs < ActiveRecord::Migration[6.1]
  def change
    create_table :akar_masalahs do |t|
      t.string :masalah_pokok
      t.string :masalah
      t.string :akar_masalah
      t.string :kode_opd
      t.string :tahun

      t.timestamps
    end
  end
end
