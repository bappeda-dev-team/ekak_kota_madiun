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
