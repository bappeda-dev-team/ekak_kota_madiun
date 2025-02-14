class VisisController < ApplicationController
  before_action :set_visi, only: %i[show edit update destroy]

  # GET /visis or /visis.json
  def index
    @tahun = cookies[:tahun]
    @lembaga = cookies[:lembaga]
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal
    @tahun_akhir = @periode.tahun_akhir

    @visis = Visi.where(tahun_awal: @tahun_awal, tahun_akhir: @tahun_akhir)
  end

  # GET /visis/1 or /visis/1.json
  def show; end

  # GET /visis/new
  def new
    @visi = Visi.new
  end

  # GET /visis/1/edit
  def edit; end

  # POST /visis or /visis.json
  def create
    @visi = Visi.new(visi_params)

    respond_to do |format|
      if @visi.save
        format.html { redirect_to visi_url(@visi), notice: "Visi was successfully created." }
        format.json { render :show, status: :created, location: @visi }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @visi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visis/1 or /visis/1.json
  def update
    respond_to do |format|
      if @visi.update(visi_params)
        format.html { redirect_to visi_url(@visi), notice: "Visi was successfully updated." }
        format.json { render :show, status: :ok, location: @visi }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @visi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visis/1 or /visis/1.json
  def destroy
    @visi.destroy

    respond_to do |format|
      format.html { redirect_to visis_url, notice: "Visi was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_visi
    @visi = Visi.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def visi_params
    params.require(:visi).permit(:visi, :urutan, :keterangan, :tahun_awal, :tahun_akhir)
  end
end
