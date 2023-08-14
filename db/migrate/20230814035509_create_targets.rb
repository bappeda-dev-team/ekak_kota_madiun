class CreateTargets < ActiveRecord::Migration[6.1]
  def change
    create_table :targets do |t|
      t.string :target
      t.string :satuan
      t.string :tahun
      t.string :jenis
      t.references :indikator
      t.references :opd

      t.timestamps
    end
  end
end
