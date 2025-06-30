class BpmnSpbesController < ApplicationController
  before_action :set_bpmn_spbe, only: %i[show edit update destroy]
  before_action :set_tahun_opd, only: %i[index pilih]

  # GET /bpmn_spbes or /bpmn_spbes.json
  def index
    @bpmn_spbes = BpmnSpbe.where(kode_opd: @kode_opd, tahun: @tahun)
  end

  def pilih
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @pokin_operationals = @opd.strategis.eselon4_bytahun(@tahun)

    @pokin_operationals = @pokin_operationals.map do |pokin|
      rekins = pokin.sasarans.includes(:user).where(tahun: @tahun)
      [pokin, rekins] if rekins.present?
    end.compact_blank!
  end

  def filter_rekap
    @tahun = params[:tahun]
    @kode_opd = params[:kode_opd]
    @opd = Opd.unscoped.find_by(kode_unik_opd: @kode_opd)

    @bpmn_spbes = if @kode_opd == '0.00.0.00.0.00.00.0000'
                    BpmnSpbe.where("tahun = ? OR dapat_digunakan_pd_lain = ?", @tahun, true)
                  else
                    BpmnSpbe.where("tahun = ? AND (kode_opd = ? OR dapat_digunakan_pd_lain = ?)", @tahun, @kode_opd,
                                   true)
                  end
    @bpmn_spbes = @bpmn_spbes.map do |bpmn|
      rekins = bpmn.sasarans.includes(:user).where(tahun: @tahun)
      [bpmn, rekins] if rekins.present?
    end.compact_blank!

    render partial: 'bpmn_spbes/filter_rekap'
  end

  # GET /bpmn_spbes/1 or /bpmn_spbes/1.json
  def show; end

  # GET /bpmn_spbes/new
  def new
    @bpmn_spbe = BpmnSpbe.new
  end

  # GET /bpmn_spbes/1/edit
  def edit; end

  # POST /bpmn_spbes or /bpmn_spbes.json
  def create
    @bpmn_spbe = BpmnSpbe.new(bpmn_spbe_params)

    respond_to do |format|
      if @bpmn_spbe.save
        format.html { redirect_to bpmn_spbe_url(@bpmn_spbe), notice: "Bpmn spbe was successfully created." }
        format.json { render :show, status: :created, location: @bpmn_spbe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bpmn_spbe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bpmn_spbes/1 or /bpmn_spbes/1.json
  def update
    respond_to do |format|
      if @bpmn_spbe.update(bpmn_spbe_params)
        format.html { redirect_to bpmn_spbe_url(@bpmn_spbe), notice: "Bpmn spbe was successfully updated." }
        format.json { render :show, status: :ok, location: @bpmn_spbe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bpmn_spbe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bpmn_spbes/1 or /bpmn_spbes/1.json
  def destroy
    @bpmn_spbe.destroy

    respond_to do |format|
      format.html { redirect_to bpmn_spbes_url, notice: "Bpmn spbe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bpmn_spbe
    @bpmn_spbe = BpmnSpbe.find(params[:id])
  end

  def set_tahun_opd
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun]
  end

  # Only allow a list of trusted parameters through.
  def bpmn_spbe_params
    params.require(:bpmn_spbe).permit(:nama_bpmn, :kode_opd, :tahun, :keterangan)
  end
end
