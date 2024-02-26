# frozen_string_literal: true

class RowRenjaComponent < ViewComponent::Base
  def initialize(no: '', title: [], periode: [], jenis: '')
    super
    @title = title
    @no = no
    @periode = periode
    @jenis = jenis
  end

  def title
    @title[1]
  end

  def kode
    @title[0]
  end

  def pagu
    0
  end

  private

  def pagu_program_kegiatan
    Indikator.where(jenis: 'Renstra',
                    sub_jenis: 'Subkegiatan',
                    tahun: tahun)
             .filter { |hh| hh.kode_bidang_urusan == kode }
             .group_by(&:kode)
             .map { |_k, v| v.max_by(&:version) }
             .inject(0) { |inj, pagu| inj + pagu.pagu.to_i }
  end
end
