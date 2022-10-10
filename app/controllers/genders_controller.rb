class GendersController < ApplicationController
  before_action :set_gender, only: %i[show edit update destroy]

  # GET /genders or /genders.json
  def index
    @genders = Gender.all
    @program_kegiatans = ProgramKegiatan.joins(:sasarans).where(sasarans: { nip_asn: current_user.nik }).group(:id)
  end

  # GET /genders/1 or /genders/1.json
  def show; end

  # GET /genders/new
  def new
    @gender = Gender.new
    @opd = current_user.opd
  end

  # GET /genders/1/edit
  def edit; end

  # POST /genders or /genders.json
  def create
    @gender = Gender.new(gender_params)

    respond_to do |format|
      if @gender.save
        format.html { redirect_to gender_url(@gender), notice: "Gender was successfully created." }
        format.json { render :show, status: :created, location: @gender }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gender.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /genders/1 or /genders/1.json
  def update
    respond_to do |format|
      if @gender.update(gender_params)
        format.html { redirect_to gender_url(@gender), notice: "Gender was successfully updated." }
        format.json { render :show, status: :ok, location: @gender }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gender.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /genders/1 or /genders/1.json
  def destroy
    @gender.destroy

    respond_to do |format|
      format.html { redirect_to genders_url, notice: "Gender was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # def gender
  #   @program_kegiatans = ProgramKegiatan.joins(:sasarans).where(sasarans: { nip_asn: current_user.nik }).group(:id)
  #   # open gender html
  # end

  def gap
    @opd = current_user.opd
    @program_kegiatans = ProgramKegiatan.where(kode_opd: @opd.kode_opd)
    render 'gap_gender'
  end

  def pdf_gender
    # nama_file = Nama subkegiatan
    @nama_file = ProgramKegiatan.find(params[:id]).nama_subkegiatan
    @tahun = params[:tahun] || Time.now.year
    @waktu = Time.now.strftime("%d_%m_%Y_%H_%M")
    @filename = "KAK_Gender_#{@nama_file}_#{@waktu}.pdf"
    @program_kegiatan = ProgramKegiatan.find(params[:id])
    render 'kak_gender.pdf'
    # render 'pdf_gap.pdf'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_gender
    @gender = Gender.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def gender_params
    params.fetch(:gender, {})
  end
end
