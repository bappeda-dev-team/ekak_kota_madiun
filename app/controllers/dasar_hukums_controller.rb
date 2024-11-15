class DasarHukumsController < ApplicationController
  before_action :set_dasar_hukum, only: %i[show edit update destroy]
  layout false, only: %i[edit new]

  # GET /dasar_hukums or /dasar_hukums.json
  def index
    @dasar_hukums = DasarHukum.all
  end

  # GET /dasar_hukums/1 or /dasar_hukums/1.json
  def show; end

  # GET /dasar_hukums/new
  def new
    @sasaran = Sasaran.find(params[:sasaran_id])
    @dasar_hukum = DasarHukum.new
  end

  # GET /dasar_hukums/1/edit
  def edit
    @sasaran = Sasaran.find(params[:sasaran_id])
  end

  # POST /dasar_hukums or /dasar_hukums.json
  def create
    @sasaran = Sasaran.find(params[:sasaran_id])
    @dasar_hukum = @sasaran.dasar_hukums.build(dasar_hukum_params)

    respond_to do |format|
      if @dasar_hukum.save
        @status = 'success'
        @text = 'Sukses menambah tematik'
        flash[:success] = "Dasar Hukum ditambahkan"
        format.js { render 'create.js.erb' }
        format.html do
          redirect_to user_sasaran_path(current_user, @sasaran), success: "Data Dasar Hukum berhasil ditambahkan"
        end
        format.json { render :show, status: :created, location: @dasar_hukum }
      else
        format.js { render :new, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dasar_hukum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dasar_hukums/1 or /dasar_hukums/1.json
  def update
    @sasaran = Sasaran.find(params[:sasaran_id])
    respond_to do |format|
      if @dasar_hukum.update(dasar_hukum_params)
        @status = 'success'
        @text = 'Sukses menambah tematik'
        flash[:success] = "Edit Dasar Hukum sukses"
        format.js { render 'create.js.erb' }
        format.html do
          redirect_to user_sasaran_path(current_user, @sasaran), success: "Data Dasar Hukum berhasil diupdate"
        end
        format.json { render :show, status: :ok, location: @dasar_hukum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dasar_hukum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dasar_hukums/1 or /dasar_hukums/1.json
  def destroy
    @sasaran = Sasaran.find(params[:sasaran_id])
    @dasar_hukum.destroy
    respond_to do |format|
      format.js
      format.html do
        redirect_to user_sasaran_path(current_user, @sasaran), success: "Dasar hukum berhasil dihapus"
      end
      format.json { head :no_content }
    end
  end

  def edit_renstra
    @max_item = params[:max_item].to_i
    @dasar_hukum = DasarHukum.find(params[:id])
    render layout: false
  end

  # TODO: validate max value of urutan
  def update_renstra
    @dasar_hukum = DasarHukum.find(params[:id])
    if @dasar_hukum.update(dasar_hukum_params)
      render json: { resText: "Perubahan tersimpan",
                     html_content: html_content({ dasar_hukum: @dasar_hukum },
                                                partial: 'dasar_hukums/dasar_hukum_renstra') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ dasar_hukum: @dasar_hukum },
                                                 partial: 'dasar_hukums/form_row') }.to_json,
             status: :unprocessable_entity
    end
  end

  def hapus_renstra
    @dasar_hukum = DasarHukum.find(params[:id])
    @dasar_hukum.destroy
    render json: { resText: "Dasar hukum berhasil dihapus", result: true }
  end

  def sort
    params[:item].each_with_index do |id, index|
      DasarHukum.find(id).update(urutan: index + 1)
    end
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dasar_hukum
    @dasar_hukum = DasarHukum.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def dasar_hukum_params
    params.require(:dasar_hukum).permit!
  end
end
