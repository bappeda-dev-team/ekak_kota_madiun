# == Schema Information
#
# Table name: manual_iks
#
#  id                   :bigint           not null, primary key
#  akhir                :string
#  budget               :string
#  definisi             :string
#  formula              :string
#  indikator_kinerja    :string
#  jenis_indikator      :string
#  key_activities       :string
#  key_milestone        :string
#  mulai                :string
#  penanggung_jawab     :string
#  penyedia_data        :string
#  periode_pelaporan    :string
#  perspektif           :string
#  rhk                  :string
#  satuan               :string
#  sumber_data          :string
#  target               :string
#  tujuan_rhk           :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  indikator_sasaran_id :string
#
class ManualIk < ApplicationRecord
  belongs_to :indikator_sasaran
  PERSPEKTIF = [
    'Penerima Layanan',
    'Proses Bisnis',
    'Penguatan Internal',
    'Anggaran'
  ].freeze

  JENIS_INDIKATOR = %w[
    Outcome
    Output
  ].freeze
end
