class PagusController < ApplicationController
  before_action :get_sasaran
  before_action :set_pagu, only: %i[ show edit update destroy ]
  before_action :set_dropdown, only: %i[ new edit ]

  # GET /pagus or /pagus.json
  def index
    # @pagus = Pagu.all
    @pagus = @sasaran.pagus
  end

  # GET /pagus/1 or /pagus/1.json
  def show
  end

  # GET /pagus/new
  def new
    # @pagu = Pagu.new
    @pagu = @sasaran.pagus.build
  end

  # GET /pagus/1/edit
  def edit
  end

  # POST /pagus or /pagus.json
  def create
    # @pagu = Pagu.new(pagu_params)
    @pagu = @sasaran.pagus.build(pagu_params)

    respond_to do |format|
      if @pagu.save
        format.html { redirect_to sasaran_path(@sasaran), notice: "Pagu was successfully created." }
        format.json { render :show, status: :created, location: @pagu }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pagu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pagus/1 or /pagus/1.json
  def update
    respond_to do |format|
      if @pagu.update(pagu_params)
        format.html { redirect_to sasaran_path(@sasaran), notice: "Pagu was successfully updated." }
        format.json { render :show, status: :ok, location: @pagu }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pagu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagus/1 or /pagus/1.json
  def destroy
    @pagu.destroy
    respond_to do |format|
      format.html { redirect_to sasarans_path(@sasaran), notice: "Pagu was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_sasaran
      @sasaran = Sasaran.find(params[:sasaran_id])
    end

    def set_pagu
      # @pagu = Pagu.find(params[:id])
      @pagu = @sasaran.pagus.find(params[:id])
    end

    def set_dropdown
      @kaks = Kak.all
    end

    # Only allow a list of trusted parameters through.
    def pagu_params
      params.require(:pagu).permit(:sasaran_id,:item, :uang, :tipe, :satuan, :volume)
    end
end
