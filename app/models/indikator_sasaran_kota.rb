# == Schema Information
#
# Table name: indikator_sasarans
#
#  id                :bigint           not null, primary key
#  aspek             :string
#  id_indikator      :string
#  indikator_kinerja :string
#  satuan            :string
#  target            :string
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :string
#
# Indexes
#
#  index_indikator_sasarans_on_id_indikator  (id_indikator) UNIQUE
#
class IndikatorSasaranKota < IndikatorSasaran
  # TODO: filter by tahun, dan get semua indikator dari awal - akhir
  belongs_to :sasaran_kota, foreign_key: 'sasaran_id', primary_key: 'id_rencana', optional: true
end
