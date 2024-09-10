class RincianBelanjaController < ApplicationController
  before_action :set_user
  before_action :set_tahun

  def index
    kak = KakQueries.new(opd: @user.opd, tahun: @tahun, user: @user)
    @subkegiatan_sasarans = kak.pk_sasarans
  end

  def index_atasan
    @subkegiatan_sasarans = @user.program_sasarans_tahun(@tahun)
  end

  def show
    @sasaran = Sasaran.find(params[:id])
  end

  def edit
    @sasaran = Sasaran.find(params[:id])
    @dikunci = @sasaran.kuncian('rankir2')
  end

  def kunci_anggaran
    @sasaran = Sasaran.find(params[:id])
    render layout: false
  end

  def kunci_keterangan
    @sasaran = Sasaran.find(params[:id])
    @jenis = params[:jenis]
    @total = params[:total]
    render layout: false
  end

  def simpan_kunci
    @sasaran = Sasaran.find(params[:id])
    @jenis = params[:jenis]
    @total = params[:total]
    keterangan = params[:keterangan]
    status_anggaran = "dikunci"
    dikunci_oleh = current_user.nik

    kunci = Kunci.new(jenis: @jenis,
                      status_kunci: status_anggaran,
                      kunciable_id: @sasaran.id,
                      kunciable_type: @sasaran.class.name,
                      keterangan: keterangan,
                      dikunci_oleh: dikunci_oleh)
    if kunci.save
      anggaran = { jenis: @jenis, total: @total, keterangan: keterangan, status: kunci.status_kunci }

      render json: { resText: "Anggaran #{@jenis} dikunci",
                     html_content: html_content({ anggaran: anggaran },
                                                partial: 'rincian_belanja/anggaran') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran: @sasaran  },
                                                 partial: 'rincian_belanja/form_kunci_anggaran') }.to_json,
             status: :unprocessable_entity
    end
  end

  def show_subkegiatan
    @subkegiatan = ProgramKegiatan.find(params[:id])
    @sasarans = @subkegiatan.sasarans_subkegiatan(@tahun)
    @rekening_sub = @subkegiatan.rekening_belanja(@tahun)
  end

  def edit_rankir_gelondong
    @sasaran = Sasaran.find(params[:id])
    @tahapans = @sasaran.tahapans.includes(%i[anggarans])
    @dikunci = @sasaran.kuncian('rankir1')
  end

  def edit_penetapan
    @sasaran = Sasaran.find(params[:id])
    @tahapans = @sasaran.tahapans.includes(%i[anggarans])
    @dikunci = @sasaran.kuncian('penetapan')
  end

  private

  def set_user
    @user = current_user
  end

  def set_tahun
    @tahun = cookies[:tahun]
  end
end
