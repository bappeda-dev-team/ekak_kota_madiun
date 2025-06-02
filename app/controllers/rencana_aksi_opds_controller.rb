class RencanaAksiOpdsController < ApplicationController
  before_action :set_rencana_aksi_opd, only: %i[show edit update destroy toggle_sasarans_is_perintah_walikota]
  layout false, only: %i[new edit]

  # GET /rencana_aksi_opds or /rencana_aksi_opds.json
  def index
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @sasaran_opds = @opd.strategi_eselon2.flat_map { |st| st.sasaran_pohon_kinerja(tahun: @tahun) }
    # @rencana_aksi_opds = RencanaAksiOpd.all
  end

  def cetak
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @jabatan_kepala_opd = opd.jabatan_kepala_tanpa_opd
    @nama_kepala_opd = opd.nama_kepala
    @nip_kepala_opd = opd.nip_kepala_fix_plt
    @pangkat_kepala_opd = opd.pangkat_kepala
    @sasaran_opds = opd.strategi_eselon2.flat_map { |st| st.sasaran_pohon_kinerja(tahun: @tahun) }

    respond_to do |format|
      format.html do
        render template: 'rencana_aksi_opds/cetak', layout: 'print.html.erb'
      end
    end
  end

  # GET /rencana_aksi_opds/1 or /rencana_aksi_opds/1.json
  def show; end

  # GET /rencana_aksi_opds/new
  def new
    @i = params[:i]
    @tahun = params[:tahun]
    @kode_opd = params[:kode_opd]
    @sasaran_opd_id = params[:sasaran_id]
    @sasaran = Sasaran.find(@sasaran_opd_id)

    @rencana_aksi_opd = RencanaAksiOpd.new(tahun: @tahun,
                                           kode_opd: @kode_opd,
                                           sasaran_id: @sasaran_opd_id)
  end

  # GET /rencana_aksi_opds/1/edit
  def edit
    @i = params[:i]
    @tahun = params[:tahun]
    @kode_opd = params[:kode_opd]
    @sasaran_opd_id = params[:sasaran_id]
    @sasaran = Sasaran.find(@sasaran_opd_id)
  end

  # POST /rencana_aksi_opds or /rencana_aksi_opds.json
  def create
    @i = params[:rencana_aksi_opd][:i]
    @tahun = rencana_aksi_opd_params[:tahun]
    @kode_opd = rencana_aksi_opd_params[:kode_opd]
    @rencana_aksi_opd = RencanaAksiOpd.new(rencana_aksi_opd_params)
    @sasaran_opd = Sasaran.find(rencana_aksi_opd_params[:sasaran_id])

    if @rencana_aksi_opd.save && @rencana_aksi_opd.update_tw_pelaksanaan
      render json: { resText: 'Renaksi OPD ditambahkan',
                     html_content: html_content({ sasaran: @sasaran_opd, i: @i },
                                                partial: 'rencana_aksi_opds/row_rencana_aksi_opd') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: html_content({ rencana_aksi_opd: @rencana_aksi_opd },
                                                partial: 'rencana_aksi_opds/form') }
        .to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rencana_aksi_opds/1 or /rencana_aksi_opds/1.json
  def update
    @i = params[:rencana_aksi_opd][:i]
    @tahun = rencana_aksi_opd_params[:tahun]
    @kode_opd = rencana_aksi_opd_params[:kode_opd]
    @sasaran_opd = Sasaran.find(rencana_aksi_opd_params[:sasaran_id])

    if @rencana_aksi_opd.update(rencana_aksi_opd_params) && @rencana_aksi_opd.update_tw_pelaksanaan
      render json: { resText: 'Sinkronisasi berhasil',
                     html_content: html_content({ sasaran: @sasaran_opd, i: @i },
                                                partial: 'rencana_aksi_opds/row_rencana_aksi_opd') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan' }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /rencana_aksi_opds/1 or /rencana_aksi_opds/1.json
  def destroy
    @i = params[:rencana_aksi_opd][:i]
    @tahun = rencana_aksi_opd_params[:tahun]
    @kode_opd = rencana_aksi_opd_params[:kode_opd]
    @sasaran_opd = Sasaran.find(rencana_aksi_opd_params[:sasaran_id])
    @rencana_aksi_opd.perintah_walikota_batal!

    @rencana_aksi_opd.destroy

    render json: { resText: 'Renaksi OPD dihapus',
                   html_content: html_content({ sasaran: @sasaran_opd, i: @i },
                                              partial: 'rencana_aksi_opds/row_rencana_aksi_opd') }
      .to_json,
           status: :ok
  end

  def toggle_sasarans_is_perintah_walikota
    @i = params[:rencana_aksi_opd][:i]
    @tahun = rencana_aksi_opd_params[:tahun]
    @kode_opd = rencana_aksi_opd_params[:kode_opd]
    @sasaran_opd = Sasaran.find(rencana_aksi_opd_params[:sasaran_id])
    rencana_renaksi = @rencana_aksi_opd.rencana_renaksi

    if rencana_renaksi.toggle!(:is_perintah_walikota)
      render json: { resText: 'Flag diubah',
                     html_content: html_content({ sasaran: @sasaran_opd, i: @i },
                                                partial: 'rencana_aksi_opds/row_rencana_aksi_opd') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan' }.to_json,
             status: :unprocessable_entity
    end
  end

  def filter_rekapitulasi
    @kode_opd = params[:opd]
    @tahun = params[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @sasaran_opds = @opd.strategi_eselon2.flat_map { |st| st.sasaran_pohon_kinerja(tahun: @tahun) }

    render partial: 'rencana_aksi_opds/filter_rekapitulasi'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rencana_aksi_opd
    @rencana_aksi_opd = RencanaAksiOpd.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def rencana_aksi_opd_params
    params.require(:rencana_aksi_opd).permit(:tw1, :tw2, :tw3, :tw4, :is_hidden, :tahun, :kode_opd,
                                             :keterangan, :id_rencana_renaksi, :sasaran_id)
  end
end
