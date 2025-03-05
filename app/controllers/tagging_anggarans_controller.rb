class TaggingAnggaransController < ApplicationController
  before_action :set_tagging_anggaran, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /tagging_anggarans or /tagging_anggarans.json
  def index
    @tagging_anggarans = TaggingAnggaran.all
  end

  # GET /tagging_anggarans/1 or /tagging_anggarans/1.json
  def show; end

  # GET /tagging_anggarans/new
  def new
    @anggaran = Anggaran.find(params[:id])
    @tagging_anggaran = @anggaran.tagging_anggarans.build
  end

  # GET /tagging_anggarans/1/edit
  def edit; end

  # POST /tagging_anggarans or /tagging_anggarans.json
  def create
    @tagging_anggaran = TaggingAnggaran.new(tagging_anggaran_params)

    if @tagging_anggaran.save
      render json: { resText: "Tagging ditambahkan",
                     html_content: html_content({ tagging_anggaran: @tagging_anggaran },
                                                partial: 'tagging_anggarans/tagging_anggaran') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ tagging_anggaran: @tagging_anggaran },
                                                 partial: 'tagging_anggarans/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tagging_anggarans/1 or /tagging_anggarans/1.json
  def update
    respond_to do |format|
      if @tagging_anggaran.update(tagging_anggaran_params)
        format.html do
          redirect_to tagging_anggaran_url(@tagging_anggaran), notice: "Tagging anggaran was successfully updated."
        end
        format.json { render :show, status: :ok, location: @tagging_anggaran }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tagging_anggaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tagging_anggarans/1 or /tagging_anggarans/1.json
  def destroy
    @tagging_anggaran.destroy

    respond_to do |format|
      format.html { redirect_to tagging_anggarans_url, notice: "Tagging anggaran was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tagging_anggaran
    @tagging_anggaran = TaggingAnggaran.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tagging_anggaran_params
    params.require(:tagging_anggaran).permit(:tagging, :anggaran_id)
  end
end
