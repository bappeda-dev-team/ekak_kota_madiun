class CloneController < ApplicationController
  def show
    pohon = Pohon.find params[:id]
    tahun = cookies[:tahun]
    render partial: 'clone/form_clone', locals: { pohon: pohon, tahun_asal: tahun }, layout: false
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
end
