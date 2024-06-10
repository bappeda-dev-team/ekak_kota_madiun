# frozen_string_literal: true

class Pohon::BranchComponent < ViewComponent::Base
  include PohonTematikHelper

  with_collection_parameter :branch

  def initialize(branch:, tahun:)
    super
    @branch = branch
    @tahun = tahun

    pohon = pohon_tematik
    @sub_tematik_kota = pohon.sub_tematiks
    @sub_sub_tematik_kota = pohon.sub_sub_tematiks
    @strategi_tematiks = pohon.strategi_tematiks
    @tactical_tematiks = pohon.tactical_tematiks
    @operational_tematiks = pohon.operational_tematiks
  end

  def pohon_tematik
    @pohon_tematik ||= PohonTematikQueries.new(tahun: @tahun)
  end

  def presenter
    PohonKotaPresenter.new(@branch)
  end

  def warna_branch
    @branch.role.chomp("_kota").dasherize
  end

  def id_branch
    dom_id(@branch)
  end
end
