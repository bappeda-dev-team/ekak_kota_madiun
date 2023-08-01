class TematiksController < ApplicationController
  before_action :set_tematik, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /tematiks or /tematiks.json
  def index
    @tematiks = Tematik.all.order(updated_at: :desc)
  end

  # GET /tematiks/1 or /tematiks/1.json
  def show; end

  # GET /tematiks/new
  def new
    @tematik = Tematik.new
  end

  # GET /tematiks/1/edit
  def edit; end

  # POST /tematiks or /tematiks.json
  def create
    @tematik = Tematik.new(tematik_params)

    respond_to do |format|
      if @tematik.save
        html_content = render_to_string(partial: 'tematiks/tematik',
                                        formats: 'html',
                                        layout: false,
                                        locals: { tematiks: index })
        format.json do
          render json: { resText: "Tematik tersimpan", attachmentPartial: html_content }.to_json, status: :created
        end
      else
        error_content = render_to_string(partial: 'tematiks/form',
                                         formats: 'html',
                                         layout: false,
                                         locals: { tematik: @tematik })
        format.json do
          render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /tematiks/1 or /tematiks/1.json
  def update
    respond_to do |format|
      if @tematik.update(tematik_params)
        format.json { render json: { resText: "Tematik diperbarui", res: @tematik }.to_json, status: :ok }
      else
        format.json do
          render json: { resText: "Gagal memperbarui", res: @tematik.errors }.to_json, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /tematiks/1 or /tematiks/1.json
  def destroy
    @tematik.destroy

    respond_to do |format|
      format.html { redirect_to tematiks_url, warning: "Tema dihapus" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tematik
    @tematik = Tematik.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tematik_params
    params.require(:tematik).permit(:tema, :keterangan, :tematik_ref_id, :type)
  end
end
