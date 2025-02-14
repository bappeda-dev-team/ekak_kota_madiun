class MisisController < ApplicationController
  before_action :set_misi, only: %i[ show edit update destroy ]

  # GET /misis or /misis.json
  def index
    @misis = Misi.all
  end

  # GET /misis/1 or /misis/1.json
  def show
  end

  # GET /misis/new
  def new
    @misi = Misi.new
  end

  # GET /misis/1/edit
  def edit
  end

  # POST /misis or /misis.json
  def create
    @misi = Misi.new(misi_params)

    respond_to do |format|
      if @misi.save
        format.html { redirect_to misi_url(@misi), notice: "Misi was successfully created." }
        format.json { render :show, status: :created, location: @misi }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @misi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /misis/1 or /misis/1.json
  def update
    respond_to do |format|
      if @misi.update(misi_params)
        format.html { redirect_to misi_url(@misi), notice: "Misi was successfully updated." }
        format.json { render :show, status: :ok, location: @misi }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @misi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /misis/1 or /misis/1.json
  def destroy
    @misi.destroy

    respond_to do |format|
      format.html { redirect_to misis_url, notice: "Misi was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_misi
      @misi = Misi.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def misi_params
      params.require(:misi).permit(:misi, :urutan, :keterangan, :tahun_awal, :tahun_akhir, :visi_id)
    end
end
