class CreateOpdBidangs < ActiveRecord::Migration[6.1]
  def change
    create_table :opd_bidangs do |t|
      t.string :nama_bidang
      t.bigint :opd_id
      t.string :kode_unik_opd
      t.string :kode_unik_bidang
      t.string :tahun
      t.string :nip_kepala
      t.string :pangkat_kepala
      t.string :id_daerah
      t.bigint :lembaga_id

      t.timestamps
    end
  end
end
