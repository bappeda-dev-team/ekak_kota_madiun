# frozen_string_literal: true

class Pohon::BranchOpdComponent < ViewComponent::Base
  include PohonKinerjaOpdsHelper

  with_collection_parameter :branch_opd

  def initialize(branch_opd:, tahun:, kode_opd:, is_root: false)
    super
    @branch_opd = branch_opd
    @tahun = tahun
    @is_root = is_root
    @kode_opd = kode_opd

    queries = pohon_kinerja
    @strategi_opd = queries.strategi_opd
    @tactical_opd = queries.tactical_opd
    @operational_opd = queries.operational_opd
    @staff_opd = queries.staff_opd
  end

  def presenter
    PohonKinerjaPresenter.new(@branch_opd)
  end

  def pohon_kinerja
    @pohon_kinerja ||= PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
  end

  def strategi_opd
    @strategi_opd ||= @pohon_kinerja.strategi_opd
  end

  def tactical_opd
    @tactical_opd ||= @pohon_kinerja.tactical_opd
  end

  def operational_opd
    @operational_opd ||= @pohon_kinerja.operational_opd
  end

  def staff_opd
    @staff_opd ||= @pohon_kinerja.staff_opd
  end

  def warna_branch
    presenter.warna_pohon
  end

  def id_branch
    dom_id(@branch_opd)
  end
end
