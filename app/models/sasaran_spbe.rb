# == Schema Information
#
# Table name: sasarans
#
#  id                     :bigint           not null, primary key
#  anggaran               :integer
#  id_rencana             :string
#  indikator_kinerja      :string
#  kualitas               :integer
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
class SasaranSpbe < Sasaran
  has_one :spbe_rincian, primary_key: :id, foreign_key: :id_rencana

  def detail_kebutuhan
    spbe_rincian.detail_kebutuhan
  end

  def uraian
    spbe_rincian.detail_sasaran_kinerja
  end

  def asn_pengusul
    user.nama
  end

  def opd_asn
    opd.nama_opd
  end
end
