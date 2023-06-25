class KebutuhansController < ApplicationController
  before_action :set_kebutuhan, only: %i[ show edit update destroy ]

  # GET /kebutuhans or /kebutuhans.json
  def index
    @kebutuhans = Kebutuhan.all
  end

  # GET /kebutuhans/1 or /kebutuhans/1.json
  def show
  end

  # GET /kebutuhans/new
  def new
    @kebutuhan = Kebutuhan.new
  end

  # GET /kebutuhans/1/edit
  def edit
  end

  # POST /kebutuhans or /kebutuhans.json
  def create
    @kebutuhan = Kebutuhan.new(kebutuhan_params)

    respond_to do |format|
      if @kebutuhan.save
        format.html { redirect_to kebutuhan_url(@kebutuhan), notice: "Kebutuhan was successfully created." }
        format.json { render :show, status: :created, location: @kebutuhan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kebutuhan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kebutuhans/1 or /kebutuhans/1.json
  def update
    respond_to do |format|
      if @kebutuhan.update(kebutuhan_params)
        format.html { redirect_to kebutuhan_url(@kebutuhan), notice: "Kebutuhan was successfully updated." }
        format.json { render :show, status: :ok, location: @kebutuhan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kebutuhan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kebutuhans/1 or /kebutuhans/1.json
  def destroy
    @kebutuhan.destroy

    respond_to do |format|
      format.html { redirect_to kebutuhans_url, notice: "Kebutuhan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kebutuhan
      @kebutuhan = Kebutuhan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kebutuhan_params
      params.require(:kebutuhan).permit(:kebutuhan, :tahun, :keterangan)
    end
end
