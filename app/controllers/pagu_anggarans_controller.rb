class PaguAnggaransController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :params_from_link, only: %i[new edit]
  before_action :set_pagu, only: %i[edit]

  layout false, only: %i[new_batasan edit_batasan edit_serapan]

  def new
    @pagu_anggaran = PaguAnggaran.new
    @kode_opd = current_user.opd.kode_opd

    render partial: 'form_pagu_anggaran'
  end

  # for substansi renstra bab 2 / serapan anggaran
  # rubocop: disable Metrics
  def edit_serapan
    periode = params[:periode].split('-')
    @tahun_awal = periode[0].to_i
    @tahun_akhir = periode[-1].to_i
    @periode = (@tahun_awal..@tahun_akhir)
    @kode = params[:kode]
    kode_opd = cookies[:opd]
    @bidang_urusan = params[:nama_bidang_urusan]
    pagu_anggarans = PaguAnggaran.where(jenis: 'PaguSerapan',
                                        sub_jenis: 'BidangUrusan',
                                        kode: @kode,
                                        kode_opd: kode_opd,
                                        tahun: @periode)
    @pagu_anggarans = if pagu_anggarans.empty?
                        @periode.map do |tahun|
                          PaguAnggaran.new(jenis: 'PaguSerapan',
                                           sub_jenis: 'BidangUrusan',
                                           kode: @kode,
                                           kode_opd: kode_opd,
                                           tahun: tahun)
                        end
                      else
                        pagu_anggarans
                      end
  end

  # for substansi renstra bab 2 / serapan anggaran
  def simpan_serapan
    pagu_params = params.permit(:authenticity_token, :commit,
                                pagu_serapans: %i[id tahun jenis sub_jenis anggaran
                                                  jenis sub_jenis kode kode_opd])
    pagus = pagu_params[:pagu_serapans]

    if pagus.blank?
      render json: { error: "No data provided" }, status: :unprocessable_entity
      return
    end

    if pagus.is_a?(Array)
      PaguAnggaran.create(pagus)
    else
      pagus.each do |id, attr|
        pagu_angg = PaguAnggaran.find(id)
        pagu_angg.update!(attr)
      end
    end

    render json: { message: "Pagus created successfully" }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def new_batasan
    tahun = params[:tahun]
    kode_opd = params[:kode_opd]
    sub_jenis = params[:sub_jenis]
    anggaran_usulan = params[:anggaran].to_i
    @pagu_anggaran = PaguAnggaran.new(jenis: 'Batasan',
                                      tahun: tahun,
                                      kode_opd: kode_opd,
                                      kode: kode_opd,
                                      sub_jenis: sub_jenis,
                                      anggaran: anggaran_usulan)
    @url = create_batasan_pagu_anggarans_path
  end

  def create_batasan
    @pagu_anggaran = PaguAnggaran.new(pagu_anggarans_params)

    if @pagu_anggaran.save
      render json: { resText: 'Pagu Batasan dibuat',
                     html_content: html_content({ pagu_anggaran: @pagu_anggaran },
                                                partial: 'pagu_anggarans/pagu_batasan') }.to_json,
             status: :ok
    else
      render json: { resText: 'Gagal menyimpan, terjadi kesalahan',
                     html_content: error_content({ pagu_anggaran: @pagu_anggaran },
                                                 partial: 'pagu_anggarans/form_batasan') }.to_json,
             status: :unprocessable_entity
    end
  end

  def edit_batasan
    @pagu_anggaran = PaguAnggaran.find(params[:id])
    @url = update_batasan_pagu_anggaran_path
  end

  def update_batasan
    @pagu_anggaran = PaguAnggaran.find(params[:id])

    if @pagu_anggaran.update(pagu_anggarans_params)
      render json: { resText: 'Perubahan Pagu Batasan disimpan',
                     html_content: html_content({ pagu_anggaran: @pagu_anggaran },
                                                partial: 'pagu_anggarans/pagu_batasan') }.to_json,
             status: :ok
    else
      render json: { resText: 'Gagal menyimpan, terjadi kesalahan',
                     html_content: error_content({ pagu_anggaran: @pagu_anggaran },
                                                 partial: 'pagu_anggarans/form_batasan') }.to_json,
             status: :unprocessable_entity
    end
  end

  def edit
    @kode_opd = current_user.opd.kode_opd
    render partial: 'form_edit_pagu_anggaran'
  end

  def create
    id_anggaran = params[:pagu_anggaran]["id_anggaran"]
    @anggaran = Anggaran.find_by_id(id_anggaran)
    @pagu_anggaran = @anggaran.create_pagu_anggaran(pagu_anggarans_params)
    respond_to do |format|
      if @pagu_anggaran.save
        format.json do
          render json: { results: {
                           anggaran: "Rp. #{number_with_delimiter(@pagu_anggaran.anggaran)}",
                           total: "Rp. #{number_with_delimiter(@anggaran.total_anggaran_penetapan)}",
                           jumlah: "Rp. #{number_with_delimiter(@anggaran.tahapan.anggaran_tahapan_penetapan)}",
                           parent: @anggaran.kode_rekening_gp
                         },
                         message: 'Tersimpan' },
                 status: :accepted
        end
      else
        format.json { render json: { results: '', message: 'Tidak Tersimpan' }, status: :unprocessable_entity }
      end
    end
  end

  def update
    id_anggaran = params[:pagu_anggaran]["id_anggaran"]
    @anggaran = Anggaran.find_by_id(id_anggaran)
    @pagu_anggaran = PaguAnggaran.find(params[:id])
    respond_to do |format|
      if @pagu_anggaran.update(pagu_anggarans_params)
        format.json do
          render json: { results: {
                           anggaran: "Rp. #{number_with_delimiter(@pagu_anggaran.anggaran)}",
                           total: "Rp. #{number_with_delimiter(@anggaran.total_anggaran_penetapan)}",
                           jumlah: "Rp. #{number_with_delimiter(@anggaran.tahapan.anggaran_tahapan_penetapan)}",
                           parent: @anggaran.kode_rekening_gp
                         },
                         message: 'Tersimpan' },
                 status: :accepted
        end
      else
        format.json { render json: { results: '', message: 'Tidak Tersimpan' }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_pagu
    @pagu_anggaran = PaguAnggaran.find(params[:id])
  end

  def set_anggaran
    @anggaran = Anggaran.find_by_id(params[:anggaran])
    @jumlah = if @anggaran.pagu_anggaran.present?
                @anggaran.anggaran_penetapan
              else
                @anggaran.jumlah
              end
    @kode = @anggaran.id
  end

  def params_from_link
    set_anggaran
    @kode_belanja = params[:kode_belanja]
    @kode_sub_belanja = params[:kode_sub_belanja]
    @jenis = params[:jenis]
    @sub_jenis = params[:sub_jenis]
    @tahun = params[:tahun]
  end

  def pagu_anggarans_params
    params.require(:pagu_anggaran).permit(:kode, :kode_opd,
                                          :kode_belanja,
                                          :kode_sub_belanja,
                                          :jenis, :sub_jenis,
                                          :keterangan,
                                          :id_anggaran,
                                          :anggaran, :tahun)
  end
end
