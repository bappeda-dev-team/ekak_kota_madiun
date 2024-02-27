# frozen_string_literal: true

class TabelRenjaComponent < ViewComponent::Base
  def initialize(sub_opd: '', urusans: '', jenis_renja: '', tahun: '')
    super
    @sub_opd = sub_opd
    @urusans = urusans
    @jenis_renja = jenis_renja
    @tahun = tahun
  end
end
