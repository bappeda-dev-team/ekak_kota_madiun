# == Schema Information
#
# Table name: master_output_kegiatans
#
#  id                     :bigint           not null, primary key
#  id_bl                  :string
#  id_kegiatan            :string
#  id_output_bl           :string           not null
#  id_program             :string
#  id_skpd                :string
#  id_sub_kegiatan        :string
#  id_sub_skpd            :string
#  indikator_kegiatan     :string
#  indikator_sub_kegiatan :string
#  satuan_kegiatan        :string
#  satuan_sub_kegiatan    :string
#  tahun                  :string
#  target_kegiatan        :string
#  target_sub_kegiatan    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_master_output_kegiatans_on_id_output_bl  (id_output_bl) UNIQUE
#
class Master::OutputKegiatan < ApplicationRecord
  def nama_opd(id_skpd:)
    Opd.find_by(id_opd_skp: id_skpd).nama_opd
  rescue NoMethodError
    'Tidak ditemukan'
  end

  def nama_program
    Master::Program.find_by(id_program_sipd: id_program).nama_program
  end

  def nama_kegiatan
    Master::Kegiatan.find_by(id_kegiatan_sipd: id_kegiatan).nama_giat
  end

  def nama_sub_kegiatan
    Master::Subkegiatan.find_by(id_sub_kegiatan_sipd: id_sub_kegiatan).nama_sub_kegiatan
  rescue NoMethodError
    id_sub_kegiatan
  end
end
