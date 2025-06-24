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
    risiko = tujuan.risiko || tujuan.build_risiko(tahun_penilaian: @tahun)

    render json: { html_content: html_content({ tujuan_kota: tujuan, risiko: risiko },
                                              partial: 'manrisks/table_form_konteks_strategis') }
      .to_json, status: :ok
  end

  def simpan_konteks_strategis
    tujuan = TujuanKota.find(risiko_params[:tujuan_kota_id])
    risiko = tujuan.risiko || tujuan.build_risiko(risiko_params)

    if risiko.update(risiko_params)
      render json: { html_content: html_content({ tujuan_kota: tujuan },
                                                partial: 'manrisks/table_konteks_strategis') }
        .to_json, status: :ok
    else

      render json: { html_content: html_content({ tujuan_kota: tujuan, risiko: risiko },
                                                partial: 'manrisks/table_form_konteks_strategis') }
        .to_json, status: :unprocessable_entity
    end
  end

  def identifikasi_strategis; end

  def filter_identifikasi_strategis
    tujuan_id = params[:filter]
    tujuan = TujuanKota.find(tujuan_id)

    render json: { html_content: html_content({ tujuan_kota: tujuan },
                                              partial: 'manrisks/identifikasi_strategis') }
      .to_json, status: :ok
  end

  private

  def set_periode_pemda
    @tahun = cookies[:tahun]
    @pemda = cookies[:lembaga]
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i
  end

  def tujuan_params
    params.require(:tujuan_kota).permit(risiko_attributes: %i[tahun_penilaian
                                                              konteks_strategis
                                                              prioritas
                                                              tujuan_kota_id
                                                              pohon_id])
  end

  def risiko_params
    params.require(:risiko).permit(%i[tahun_penilaian konteks_strategis
                                      prioritas tujuan_kota_id pohon_id])
  end
end
