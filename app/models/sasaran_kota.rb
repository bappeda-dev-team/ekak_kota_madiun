# == Schema Information
#
# Table name: sasarans
#
#  id                     :bigint           not null, primary key
#  anggaran               :integer
#  id_rencana             :string
#  indikator_kinerja      :string
#  jenis_layanan          :string
#  keterangan             :string
#  kualitas               :integer
#  metadata               :jsonb
#  nip_asn                :string
#  nip_asn_sebelumnya     :string
#  penerima_manfaat       :string
#  sasaran_atasan         :string
#  sasaran_kinerja        :string
#  sasaran_kota           :string
#  sasaran_milik          :string
#  sasaran_opd            :string
#  satuan                 :string
#  status                 :enum             default("draft")
#  sumber_dana            :string
#  tahun                  :string
#  target                 :integer
#  type                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  opd_id                 :bigint
#  program_kegiatan_id    :bigint
#  sasaran_atasan_id      :string
#  strategi_id            :string
#  subkegiatan_tematik_id :bigint
#
# Indexes
#
#  index_sasarans_on_id_rencana  (id_rencana) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (nip_asn => users.nik)
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
#
class SasaranKota < Sasaran
  def visi
    sasaran_kota
  end

  def misi
    sasaran_opd
  end

  def tujuan
    sasaran_atasan
  end
end
