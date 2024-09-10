class CreateKuncis < ActiveRecord::Migration[6.1]
  def change
    create_table :kuncis do |t|
      t.string :jenis
      t.string :status_kunci
      t.string :dikunci_oleh
      t.string :keterangan
      t.string :tahun
      t.string :kode_opd
      t.references :kunciable, polymorphic: true

      t.timestamps
    end
  end
end
