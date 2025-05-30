class TahapansController < ApplicationController
  before_action :get_sasaran
  before_action :set_tahapan, only: %i[show edit update destroy review review_anggaran]
  layout false, only: %i[edit new edit_tagging]

  # GET /tahapans or /tahapans.json
  def index
    # @tahapans = Tahapan.all
    @tahapans = @sasaran.tahapans
  end

  # GET /tahapans/1 or /tahapans/1.json
  def show; end

  # GET /tahapans/new
  def new
    # @tahapan = Tahapan.new
    @reload = params[:reload]
    @tahapan = @sasaran.tahapans.build
  end

  # GET /tahapans/1/edit
  def edit; end

  def edit_tagging
    @tahapan = @sasaran.tahapans.find(params[:id])
  end

  # POST /tahapans or /tahapans.json
  def create
    # @tahapan = Tahapan.new(tahapan_params)
    @tahapan = @sasaran.tahapans.build(tahapan_params)
    @tahapan.id_rencana = @sasaran.id_rencana
    @tahapan.id_rencana_aksi = SecureRandom.base36(6)
    if @tahapan.save
      render json: { resText: "Renaksi berhasil dibuat.",
                     html_content: html_content({ sasaran: @sasaran,
                                                  tahapan: @tahapan },
                                                partial: 'tahapans/tahapan') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran: @sasaran,
                                                   tahapan: @tahapan },
                                                 partial: 'tahapans/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tahapans/1 or /tahapans/1.json
  def update
    if @tahapan.update(tahapan_params)
      render json: { resText: "Renaksi diupdate.",
                     html_content: html_content({ sasaran: @sasaran,
                                                  tahapan: @tahapan },
                                                partial: 'tahapans/tahapan') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran: @sasaran,
                                                   tahapan: @tahapan },
                                                 partial: 'tahapans/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /tahapans/1 or /tahapans/1.json
  def destroy
    @tahapan.destroy
    render json: { resText: "Renaksi dihapus." }.to_json,
           status: :accepted
  end

  def otomatis
    @sasaran = Sasaran.find(params[:sasaran_id])
    manual_ik = @sasaran.indikator_sasarans.first.manual_ik.key_activities
    @tahapan = @sasaran.tahapans.build
    @tahapan.tahapan_kerja = manual_ik
    @tahapan.id_rencana = @sasaran.id_rencana
    @tahapan.id_rencana_aksi = SecureRandom.base36(6)
    respond_to do |format|
      if @tahapan.save
        flash[:success] = "Sukses menambahkan tahapan"
        format.js { render 'update.js.erb' }
        format.html { redirect_to sasaran_path(@sasaran) }
        format.json { render :show, status: :created, location: @tahapan }
      else
        flash[:error] = "Terjadi kesalahan"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tahapan.errors, status: :unprocessable_entity }
      end
    end
  end

  def review; end

  def review_anggaran; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def get_sasaran
    @sasaran = Sasaran.find(params[:sasaran_id])
  end

  def set_tahapan
    @tahapan = @sasaran.tahapans.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tahapan_params
    params.require(:tahapan).permit(:sasaran_id, :tahapan_kerja, :target, :realisasi, :bulan, :jumlah_target, :urutan,
                                    :jumlah_realisasi, :keterangan, :waktu, :progress, :tagging)
  end
end
