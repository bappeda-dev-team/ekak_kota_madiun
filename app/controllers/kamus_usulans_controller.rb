class KamusUsulansController < ApplicationController
  before_action :set_kamus_usulan, only: %i[ show edit update destroy ]

  # GET /kamus_usulans or /kamus_usulans.json
  def index
    @kamus_usulans = KamusUsulan.all
  end

  # GET /kamus_usulans/1 or /kamus_usulans/1.json
  def show
  end

  # GET /kamus_usulans/new
  def new
    @kamus_usulan = KamusUsulan.new
  end

  # GET /kamus_usulans/1/edit
  def edit
  end

  # POST /kamus_usulans or /kamus_usulans.json
  def create
    @kamus_usulan = KamusUsulan.new(kamus_usulan_params)

    respond_to do |format|
      if @kamus_usulan.save
        format.html { redirect_to kamus_usulan_url(@kamus_usulan), notice: "Kamus usulan was successfully created." }
        format.json { render :show, status: :created, location: @kamus_usulan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kamus_usulan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kamus_usulans/1 or /kamus_usulans/1.json
  def update
    respond_to do |format|
      if @kamus_usulan.update(kamus_usulan_params)
        format.html { redirect_to kamus_usulan_url(@kamus_usulan), notice: "Kamus usulan was successfully updated." }
        format.json { render :show, status: :ok, location: @kamus_usulan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kamus_usulan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kamus_usulans/1 or /kamus_usulans/1.json
  def destroy
    @kamus_usulan.destroy

    respond_to do |format|
      format.html { redirect_to kamus_usulans_url, notice: "Kamus usulan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kamus_usulan
      @kamus_usulan = KamusUsulan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kamus_usulan_params
      params.fetch(:kamus_usulan, {})
    end
end
