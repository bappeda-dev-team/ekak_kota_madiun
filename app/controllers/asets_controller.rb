class AsetsController < ApplicationController
  before_action :set_aset, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /asets or /asets.json
  def index
    @asets = Aset.all
  end

  # GET /asets/1 or /asets/1.json
  def show; end

  # GET /asets/new
  def new
    @aset = Aset.new
  end

  # GET /asets/1/edit
  def edit; end

  # POST /asets or /asets.json
  def create
    @aset = Aset.new(aset_params)

    if @aset.save
      render json: { resText: 'Aset OPD ditambahkan',
                     html_content: html_content({ aset: @aset },
                                                partial: 'asets/aset') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ aset: @aset },
                                                 partial: 'asets/form_row') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /asets/1 or /asets/1.json
  def update
    respond_to do |format|
      if @aset.update(aset_params)
        format.html { redirect_to aset_url(@aset), notice: "Aset was successfully updated." }
        format.json { render :show, status: :ok, location: @aset }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @aset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asets/1 or /asets/1.json
  def destroy
    @aset.destroy

    respond_to do |format|
      format.html { redirect_to asets_url, notice: "Aset was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_aset
    @aset = Aset.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def aset_params
    params.require(:aset).permit(:nama_aset, :jumlah, :satuan, :kondisi, :tahun_awal, :tahun_akhir, :keterangan)
  end
end
