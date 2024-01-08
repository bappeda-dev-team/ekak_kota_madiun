class DataDukungsController < ApplicationController
  before_action :set_data_dukung, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /data_dukungs or /data_dukungs.json
  def index
    @data_dukungs = DataDukung.all
  end

  # GET /data_dukungs/1 or /data_dukungs/1.json
  def show; end

  # GET /data_dukungs/new
  def new
    @permasalahan = PermasalahanOpd.find(params[:permasalahan_id])
    @data_dukung = @permasalahan.data_dukungs.build
  end

  # GET /data_dukungs/1/edit
  def edit; end

  # POST /data_dukungs or /data_dukungs.json
  def create
    @data_dukung = DataDukung.new(data_dukung_params)

    if @data_dukung.save
      render json: { resText: "Data dukung ditambahkan",
                     html_content: html_content({ data_dukung: @data_dukung },
                                                partial: 'data_dukungs/data_dukung') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ data_dukung: @data_dukung },
                                                 partial: 'data_dukungs/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /data_dukungs/1 or /data_dukungs/1.json
  def update
    respond_to do |format|
      if @data_dukung.update(data_dukung_params)
        format.html { redirect_to data_dukung_url(@data_dukung), notice: "Data dukung was successfully updated." }
        format.json { render :show, status: :ok, location: @data_dukung }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @data_dukung.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_dukungs/1 or /data_dukungs/1.json
  def destroy
    @data_dukung.destroy

    respond_to do |format|
      format.html { redirect_to data_dukungs_url, notice: "Data dukung was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_data_dukung
    @data_dukung = DataDukung.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def data_dukung_params
    params.require(:data_dukung).permit(:nama_data, :keterangan, :data_dukungable_type, :data_dukungable_id)
  end
end
