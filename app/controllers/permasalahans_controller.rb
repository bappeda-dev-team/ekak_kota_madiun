class PermasalahansController < ApplicationController
  before_action :set_permasalahan, only: %i[show edit update destroy]

  # GET /permasalahans or /permasalahans.json
  def index
    @permasalahans = Permasalahan.all
  end

  # GET /permasalahans/1 or /permasalahans/1.json
  def show; end

  # GET /permasalahans/new
  def new
    @sasaran = Sasaran.find(params[:sasaran_id])
    @permasalahan = Permasalahan.new
  end

  # GET /permasalahans/1/edit
  def edit
    @sasaran = Sasaran.find(params[:sasaran_id])
  end

  # POST /permasalahans or /permasalahans.json
  def create
    @sasaran = Sasaran.find(params[:sasaran_id])
    @permasalahan = @sasaran.permasalahans.build(permasalahan_params)

    respond_to do |format|
      if @permasalahan.save
        @status = 'success'
        @text = 'Sukses menambah tematik'
        flash[:success] = "Permaslahaan ditambahkan"
        format.js { render 'create.js.erb' }
        format.html do
          redirect_to user_sasaran_path(current_user, @sasaran), success: "Data Permasalahan berhasil ditambahkan"
        end
        format.json { render :show, status: :created, location: @permasalahan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @permasalahan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permasalahans/1 or /permasalahans/1.json
  def update
    @sasaran = Sasaran.find(params[:sasaran_id])
    respond_to do |format|
      if @permasalahan.update(permasalahan_params)
        @status = 'success'
        @text = 'Sukses menambah tematik'
        flash[:success] = "Edit rincian sukses"
        format.js { render 'create.js.erb' }
        format.html do
          redirect_to user_sasaran_path(current_user, @sasaran), success: "Data Permasalahan berhasil diupdate"
        end
        format.json { render :show, status: :ok, location: @permasalahan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @permasalahan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permasalahans/1 or /permasalahans/1.json
  def destroy
    @permasalahan.destroy

    respond_to do |format|
      format.html { redirect_to permasalahans_url, notice: "Permasalahan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_permasalahan
    @permasalahan = Permasalahan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def permasalahan_params
    params.require(:permasalahan).permit(:permasalahan, :jenis, :penyebab_internal, :penyebab_external)
  end
end
