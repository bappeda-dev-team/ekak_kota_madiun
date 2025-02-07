class ManrisksController < ApplicationController
  before_action :set_periode_pemda

  def konteks_strategis; end

  def filter
    tujuan_id = params[:filter]
    tujuan = TujuanKota.find(tujuan_id)

    render json: { html_content: html_content({ tujuan_kota: tujuan },
                                              partial: 'manrisks/konteks_strategis') }
      .to_json, status: :ok
  end

  # manrisk is composed by tujuan kota
  def edit_konteks_strategis
    tujuan = TujuanKota.find(params[:id])
    tujuan.build_risiko(tahun_penilaian: @tahun)

    render json: { html_content: html_content({ tujuan_kota: tujuan },
                                              partial: 'manrisks/table_form_konteks_strategis') }
      .to_json, status: :ok
  end

  def simpan_konteks_strategis; end

  private

  def set_periode_pemda
    @tahun = cookies[:tahun]
    @pemda = cookies[:lembaga]
    @periode = Periode.find_tahun(@tahun)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i
  end
end
