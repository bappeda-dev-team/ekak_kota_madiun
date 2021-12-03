class PajaksController < ApplicationController
  before_action :set_pajak, only: %i[ show edit update destroy ]

  # GET /pajaks or /pajaks.json
  def index
    @pajaks = Pajak.all
  end

  # GET /pajaks/1 or /pajaks/1.json
  def show
  end

  # GET /pajaks/new
  def new
    @pajak = Pajak.new
  end

  # GET /pajaks/1/edit
  def edit
  end

  # POST /pajaks or /pajaks.json
  def create
    @pajak = Pajak.new(pajak_params)

    respond_to do |format|
      if @pajak.save
        format.html { redirect_to @pajak, notice: "Pajak was successfully created." }
        format.json { render :show, status: :created, location: @pajak }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pajak.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pajaks/1 or /pajaks/1.json
  def update
    respond_to do |format|
      if @pajak.update(pajak_params)
        format.html { redirect_to @pajak, notice: "Pajak was successfully updated." }
        format.json { render :show, status: :ok, location: @pajak }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pajak.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pajaks/1 or /pajaks/1.json
  def destroy
    @pajak.destroy
    respond_to do |format|
      format.html { redirect_to pajaks_url, notice: "Pajak was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pajak
      @pajak = Pajak.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pajak_params
      params.require(:pajak).permit(:tahun, :tipe, :potongan)
    end
end
