class CreateRenstras < ActiveRecord::Migration[6.1]
  def change
    create_table :renstras do |t|
      t.string :visi
      t.string :misi
      t.string :tujuan
      t.string :sasaran
      t.string :strategi
      t.string :id_bidang_urusan
      t.string :kode_bidang_urusan
      t.string :nama_bidang_urusan
      t.string :id_program_sipd
      t.string :kode_program
      t.string :nama_program
      t.string :indikator_program
      t.string :id_rpjmd_sipd
      t.string :id_giat_sipd
      t.string :kode_giat
      t.string :nama_giat
      t.string :indikator_kegiatan
      t.string :target_giat_1
      t.string :target_giat_2
      t.string :target_giat_3
      t.string :target_giat_4
      t.string :target_giat_5
      t.string :pagu_giat_1
      t.string :pagu_giat_2
      t.string :pagu_giat_3
      t.string :pagu_giat_4
      t.string :pagu_giat_5
      t.string :satuan_target_giat
      t.string :id_sub_giat_sipd
      t.string :kode_sub_giat
      t.string :nama_sub_giat
      t.string :indikator_sub_giat
      t.string :target_sub_giat_1
      t.string :target_sub_giat_2
      t.string :target_sub_giat_3
      t.string :target_sub_giat_4
      t.string :target_sub_giat_5
      t.string :pagu_sub_giat_1
      t.string :pagu_sub_giat_2
      t.string :pagu_sub_giat_3
      t.string :pagu_sub_giat_4
      t.string :pagu_sub_giat_5
      t.string :satuan_target_sub_giat
      t.string :id_unit
      t.string :id_skpd
      t.string :kode_skpd
      t.string :nama_skpd
      t.string :id_renstra
      t.timestamps

      t.index :id_renstra, unique: true
    end
  end
end
