class PksController < ApplicationController
  before_action :set_pk, only: %i[ show edit update destroy ]

  # GET /pks or /pks.json
  def index
    @pks = Pk.all
  end

  # GET /pks/1 or /pks/1.json
  def show
  end

  # GET /pks/new
  def new
    @pk = Pk.new
  end

  # GET /pks/1/edit
  def edit
  end

  # POST /pks or /pks.json
  def create
    @pk = Pk.new(pk_params)

    respond_to do |format|
      if @pk.save
        format.html { redirect_to @pk, notice: "Pk was successfully created." }
        format.json { render :show, status: :created, location: @pk }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pks/1 or /pks/1.json
  def update
    respond_to do |format|
      if @pk.update(pk_params)
        format.html { redirect_to @pk, notice: "Pk was successfully updated." }
        format.json { render :show, status: :ok, location: @pk }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pks/1 or /pks/1.json
  def destroy
    @pk.destroy
    respond_to do |format|
      format.html { redirect_to pks_url, notice: "Pk was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pk
      @pk = Pk.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pk_params
      params.require(:pk).permit(:sasaran, :indikator_kinerja, :target, :satuan, :user_id)
    end
end
