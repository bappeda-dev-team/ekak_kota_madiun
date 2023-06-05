class CreateSpbes < ActiveRecord::Migration[6.1]
  def change
    create_table :spbes do |t|
      t.string :jenis_pelayanan
      t.string :nama_aplikasi
      t.string :kode_program
      t.string :kode_opd
      t.string :strategi_ref_id

      t.references :program_kegiatan, index: false
      t.timestamps
    end
  end
end
