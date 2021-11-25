class PagusController < ApplicationController
  before_action :set_pagu, only: %i[ show edit update destroy ]
  before_action :set_dropdown, only: %i[ new edit ]

  # GET /pagus or /pagus.json
  def index
    @pagus = Pagu.all
  end

  # GET /pagus/1 or /pagus/1.json
  def show
  end

  # GET /pagus/new
  def new
    @pagu = Pagu.new
  end

  # GET /pagus/1/edit
  def edit
  end

  # POST /pagus or /pagus.json
  def create
    @pagu = Pagu.new(pagu_params)

    respond_to do |format|
      if @pagu.save
        format.html { redirect_to @pagu, notice: "Pagu was successfully created." }
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
        format.html { redirect_to @pagu, notice: "Pagu was successfully updated." }
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
      format.html { redirect_to pagus_url, notice: "Pagu was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pagu
      @pagu = Pagu.find(params[:id])
    end

    def set_dropdown
      @kaks = Kak.all
    end

    # Only allow a list of trusted parameters through.
    def pagu_params
      params.require(:pagu).permit(:kak_id, :item, :uang, :tipe, :satuan, :volume)
    end
end
