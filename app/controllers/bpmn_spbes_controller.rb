class BpmnSpbesController < ApplicationController
  before_action :set_bpmn_spbe, only: %i[show edit update destroy]
  before_action :set_tahun_opd, only: %i[index pilih]
  layout false, only: %i[new edit tambah_catatan]

  # GET /bpmn_spbes or /bpmn_spbes.json
  def index
    @bpmn_spbes = BpmnSpbe.where(kode_opd: @kode_opd, tahun: @tahun)
  end

  def pilih
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @pokin_operationals = @opd.strategis.eselon4_bytahun(@tahun)

    @pokin_operationals = @pokin_operationals.map do |pokin|
      rekins = pokin.sasarans.dengan_nip.includes(:user).where(tahun: @tahun)
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
    @bpmn_spbes = @bpmn_spbes.filter do |bpmn|
      rekins = if @kode_opd == '0.00.0.00.0.00.00.0000'
                 bpmn.sasarans.dengan_nip.includes(:user).where(tahun: @tahun)
               else
                 bpmn.sasarans.dengan_nip.includes(:user).where(tahun: @tahun, user: { kode_opd: @opd.kode_opd })
               end
      rekins.any?
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
  def edit
    @sasaran = Sasaran.find(params[:sasaran_id])
  end

  # hanya di rekap laporan spbe
  def tambah_catatan
    @bpmn_spbe = BpmnSpbe.find(params[:id])
    render partial: 'form_tambah_catatan', locals: { bpmn_spbe: @bpmn_spbe }
  end

  def simpan_catatan
    @bpmn_spbe = BpmnSpbe.find(params[:id])
    if @bpmn_spbe.update(bpmn_spbe_params)
      render json: {
        resText: 'Catatan berhasil ditambahkan',
        html_content: html_content({ bpmn_spbe: @bpmn_spbe }, partial: 'bpmn_spbes/row_filter_rekap')
      }.to_json, status: :ok
    else
      render json: { resText: 'Gagal memperbarui BPMN SPBE' }.to_json, status: :unprocessable_entity
    end
  end

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
    @sasaran = Sasaran.find(params[:sasaran_id])
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    if @bpmn_spbe.update(bpmn_spbe_params)
      render json: {
        resText: 'BPMN SPBE berhasil diperbarui',
        html_content: html_content({ sasaran: @sasaran }, partial: 'sasarans/sasaran_bpmn')
      }.to_json, status: :ok
    else
      render json: { resText: 'Gagal memperbarui BPMN SPBE' }.to_json, status: :unprocessable_entity
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
    params.require(:bpmn_spbe).permit(:nama_bpmn, :kode_opd, :tahun, :keterangan, :dapat_digunakan_pd_lain)
  end
end
