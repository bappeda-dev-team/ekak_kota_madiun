class CreateKolabs < ActiveRecord::Migration[6.1]
  def change
    create_table :kolabs do |t|
      t.string :kolabable_type
      t.bigint :kolabable_id
      t.string :jenis
      t.string :kode_unik_opd
      t.string :tahun
      t.string :status
      t.string :keterangan

      t.timestamps
    end
  end
end
