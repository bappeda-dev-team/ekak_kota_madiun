class CloneController < ApplicationController
  def show
    pohon = Pohon.find params[:id]
    tahun = cookies[:tahun]
    url = pohon_tematik_clone_path(pohon)
    render partial: 'clone/form_clone', locals: { pohon: pohon, tahun_asal: tahun, url: url }, layout: false
  end

  def pohon_tematik
    tahun_asal = params[:tahun_asal]
    tahun_anggaran = KelompokAnggaran.find(params[:tahun_tujuan]).kode_kelompok
    @tahun = tahun_anggaran.match(/murni/) ? tahun_anggaran[/[^_]\d*/, 0] : tahun_anggaran

    pohon = Pohon.find(params[:id])

    ket = "clone_dari_#{tahun_asal}"

    operation = PohonCloner.call(pohon, traits: :pohon_tematik,
                                        tahun: @tahun, pohon_ref_id: '', keterangan: ket)
    operation.to_record
    if operation.persist!
      clone_pohon = operation.to_record
      render json: { resText: "Pohon di clone ke #{clone_pohon.tahun}" }, status: :created
    else
      render json: { resText: 'Gagal, terdapat kesalahan di server' }, status: :unprocessable_entity
    end
  end

  def clone_sasaran
    sasaran = Sasaran.find params[:id]
    tahun = cookies[:tahun]
    url = rencana_kinerja_clone_path(sasaran)
    render partial: 'clone/form_clone_sasaran', locals: { sasaran: sasaran, tahun_asal: tahun, url: url }, layout: false
  end

  def rencana_kinerja
    tahun_asal = params[:tahun_asal]
    tahun_anggaran = KelompokAnggaran.find(params[:tahun_tujuan]).kode_kelompok
    @tahun = tahun_anggaran.match(/murni/) ? tahun_anggaran[/[^_]\d*/, 0] : tahun_anggaran
    sasaran = Sasaran.find(params[:id])

    ket = "clone_#{tahun_asal}"

    operation = SasaranCloner.call(sasaran,
                                   traits: :with_indikators,
                                   tahun: @tahun)
    operation.to_record
    if operation.persist!
      clone_sasaran = operation.to_record
      render json: { resText: "Sasaran #{clone_sasaran} di clone ke #{clone_sasaran.tahun}" },
             status: :created
    else
      render json: { resText: 'Gagal, terdapat kesalahan di server' },
             status: :unprocessable_entity
    end
  end

  def tahun_clone
    tahun_asal = cookies[:tahun]
    url = params[:url]
    render partial: 'clone/form_tahun_clone', locals: { judul: params[:judul], tahun_asal: tahun_asal, url: url },
           layout: false
  end

  def transfer_ke_pohon_kinerja
    strategis = Strategi.where(tahun: params[:tahun], role: params[:role], opd_id: params[:opd])
    tahun_tujuan = params[:tahun_tujuan]
    return unless strategis.any?

    results = strategis.map do |strategi|
      operation = StrategiCloner.call(strategi, tahun: tahun_tujuan,
                                                opd_id: params[:opd],
                                                strategi_cascade_link: strategi.id,
                                                traits: [:no_bawahan])
      operation.to_record
      operation.persist!
    end
    if results.any?
      render json: { resText: "Berhasil clone ke #{tahun_tujuan}" }, status: :created
    else
      render json: { resText: 'Gagal, terdapat kesalahan di server' }, status: :unprocessable_entity
    end
  end
end
