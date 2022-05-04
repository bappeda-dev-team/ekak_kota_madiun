class SasaransController < ApplicationController
  before_action :get_user, only: %i[index new create update destroy]
  before_action :set_sasaran, only: %i[show edit update destroy update_program_kegiatan renaksi_update]
  before_action :set_dropdown, only: %i[new edit]

  # GET /sasarans or /sasarans.json
  def index
    @sasarans = @user.sasarans
  end

  # GET /sasarans/1 or /sasarans/1.json
  def show; end

  def sasaran_admin; end

  def daftar_subkegiatan
    @sasarans = Sasaran.includes(:program_kegiatan).where.not(program_kegiatan: { id: nil })
  end

  def pdf_daftar_subkegiatan; end

  def hapus_program_from_sasaran
    param_id = params[:id_sasaran]
    sasaran = Sasaran.find(param_id)
    respond_to do |format|
      if sasaran.update(program_kegiatan_id: nil)
        @status = 'success'
        @text = 'Sukses menghapus program kegiatan'
        format.js
      else
        @status = 'error'
        @text = 'Terjadi kesalahan saat menghapus program kegiatan'
        format.js :unprocessable_entity
      end
    end
  end

  def hapus_tematik_from_sasaran
    id_sasaran = params[:id_sasaran]
    id_tematik = params[:id_tematik]
    TematikSasaran.where(sasaran_id: id_sasaran, subkegiatan_tematik_id: id_tematik).first.destroy
    respond_to do |format|
      @status = 'success'
      @text = 'Sukses menghapus tematik'
      format.js { render :hapus_program_from_sasaran }
    end
  end

  def add_sasaran_tematik
    sasaran = Sasaran.find(params[:id_sasaran])
    tematik = params[:id_tematik]
    respond_to do |format|
      if sasaran.add_tematik(sasaran: sasaran.id, tematik: tematik)
        @status = 'success'
        @text = 'Sukses menambah tematik'
        format.js { render :hapus_program_from_sasaran }
      else
        @status = 'error'
        @text = 'Terjadi kesalahan saat menambah tematik'
        format.js { render :hapus_program_from_sasaran, :unprocessable_entity }
      end
    end
  end

  def renaksi_update
    @sasaran.sync_total_renaksi
  end

  # GET /sasarans/new
  def new
    @sasaran = @user.sasarans.build
    @sasaran.build_rincian
  end

  # GET /sasarans/1/edit
  def edit
    @sasaran.build_rincian if @sasaran.rincian.nil?
  end

  # POST /sasarans or /sasarans.json
  def create
    @sasaran = @user.sasarans.build(sasaran_params)
    @sasaran.id_rencana = SecureRandom.base36(6)
    respond_to do |format|
      if @sasaran.save
        format.html { redirect_to user_sasaran_path(@user, @sasaran), notice: 'Sasaran was successfully created.' }
        format.json { render :show, status: :created, location: @sasaran }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sasaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sasarans/1 or /sasarans/1.json
  def update
    respond_to do |format|
      if @sasaran.update(sasaran_params)
        flash[:success] = if sasaran_params[:program_kegiatan_id]
                            'Sukses menambah subkegiatan'
                          else
                            'Sukses update sasaran'
                          end
        format.js
        format.html { redirect_to user_sasaran_path(@user, @sasaran) }
        format.json { render :show, status: :ok, location: @sasaran }
      else
        flash.now[:error] = 'Sasaran gagal update.'
        format.js
        format.html { redirect_to user_sasaran_path(@user, @sasaran), error: 'Sasaran gagal update.' }
        format.json { render json: @sasaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sasarans/1 or /sasarans/1.json
  def destroy
    @sasaran.destroy
    respond_to do |format|
      format.html { redirect_to sasarans_path, notice: 'Sasaran was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def get_user
    @user = current_user
  end

  def get_program_kegiatan
    @program_kegiatan = ProgramKegiatan.find(params[:program_kegiatan_id])
  end

  def set_sasaran
    @sasaran = Sasaran.find(params[:id])
  end

  def set_dropdown
    @users = User.all
  end

  # Only allow a list of trusted parameters through.
  def sasaran_params
    params.require(:sasaran).permit(:sasaran_kinerja, :indikator_kinerja, :target, :kualitas,
                                    :satuan, :penerima_manfaat, :nip_asn, :program_kegiatan_id,
                                    :sumber_dana, :subkegiatan_tematik_id)
  end

  rescue_from ActionController::ParameterMissing do
    render 'shared/_notifier', locals: { message: 'isian belum terisi' }, status: :unprocessable_entity
  end
end
