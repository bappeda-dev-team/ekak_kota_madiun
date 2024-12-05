class CreateInovasiMasyarakats < ActiveRecord::Migration[6.1]
  def change
    create_table :inovasi_masyarakats do |t|
      t.string :nama_pelapor
      t.string :no_whatsapp
      t.string :alamat
      t.string :email_pelapor
      t.string :inovasi
      t.string :gambaran_nilai_kebaruan
      t.string :status_laporan
      t.string :keterangan
      t.jsonb :metadata
      t.string :id_tiket

      t.timestamps
    end
    add_index :inovasi_masyarakats, :id_tiket, unique: true
  end
end
