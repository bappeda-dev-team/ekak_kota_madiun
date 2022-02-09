class SasaransController < ApplicationController
  before_action :get_user, only: %i[index create new]
  before_action :set_sasaran, only: %i[ show edit update destroy update_program_kegiatan ]
  before_action :set_dropdown, only: %i[ new edit ]

  # GET /sasarans or /sasarans.json
  def index
    @sasarans = @user.sasarans
  end

  # GET /sasarans/1 or /sasarans/1.json
  def show
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

    respond_to do |format|
      if @sasaran.save
        format.html { redirect_to user_path(@user), notice: "Sasaran was successfully created." }
        format.json { render :show, status: :created, location: @sasaran }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sasaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sasarans/1 or /sasarans/1.json
  def update
    user = @sasaran.user.id

    respond_to do |format|
      if @sasaran.update(sasaran_params)
        format.html { redirect_to sasaran_path, notice: "Sasaran was successfully updated." }
        format.json { render :show, status: :ok, location: @sasaran }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sasaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sasarans/1 or /sasarans/1.json
  def destroy
    user = @sasaran.user.id
    @sasaran.destroy
    respond_to do |format|
      format.html { redirect_to sasaran_path, notice: "Sasaran was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def get_user
    @user = User.find(params[:user_id])
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
                                    :satuan, :penerima_manfaat, :user_id, :program_kegiatan_id,
                                    rincian_attributes: [:data_terpilah, :penyebab_internal, :penyebab_external,
                                                         :permasalahan_umum, :permasalahan_gender, :resiko, :lokasi_pelaksanaan])
  end
end
