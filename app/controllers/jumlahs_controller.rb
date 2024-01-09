class JumlahsController < ApplicationController
  before_action :set_jumlah, only: %i[ show edit update destroy ]

  # GET /jumlahs or /jumlahs.json
  def index
    @jumlahs = Jumlah.all
  end

  # GET /jumlahs/1 or /jumlahs/1.json
  def show
  end

  # GET /jumlahs/new
  def new
    @jumlah = Jumlah.new
  end

  # GET /jumlahs/1/edit
  def edit
  end

  # POST /jumlahs or /jumlahs.json
  def create
    @jumlah = Jumlah.new(jumlah_params)

    respond_to do |format|
      if @jumlah.save
        format.html { redirect_to jumlah_url(@jumlah), notice: "Jumlah was successfully created." }
        format.json { render :show, status: :created, location: @jumlah }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @jumlah.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jumlahs/1 or /jumlahs/1.json
  def update
    respond_to do |format|
      if @jumlah.update(jumlah_params)
        format.html { redirect_to jumlah_url(@jumlah), notice: "Jumlah was successfully updated." }
        format.json { render :show, status: :ok, location: @jumlah }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jumlah.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jumlahs/1 or /jumlahs/1.json
  def destroy
    @jumlah.destroy

    respond_to do |format|
      format.html { redirect_to jumlahs_url, notice: "Jumlah was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jumlah
      @jumlah = Jumlah.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jumlah_params
      params.require(:jumlah).permit(:jumlah, :satuan, :tahun, :keterangan)
    end
end
