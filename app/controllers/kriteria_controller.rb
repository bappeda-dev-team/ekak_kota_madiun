class KriteriaController < ApplicationController
  before_action :set_kriterium, only: %i[show edit update destroy]
  layout false, only: %i[new edit edit_sub show]

  # GET /kriteria or /kriteria.json
  def index
    @kriteria = Kriterium.all.where(type: [nil, ''])
  end

  # GET /kriteria/1 or /kriteria/1.json
  def show
    @skor = params[:skor]
  end

  # GET /kriteria/new
  def new
    @kriterium = klass.new
    @target = 'kriteria'
  end

  # GET /kriteria/1/edit
  def edit; end

  # POST /kriteria or /kriteria.json
  def create
    @kriterium = klass.new(kriterium_params)

    if @kriterium.save
      render json: { resText: "Kriteria baru dibuat", html_content: html_content(@kriterium) }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan", html_content: error_content(@kriterium) }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /kriteria/1 or /kriteria/1.json
  def update
    if @kriterium.update(kriterium_params)
      render json: { resText: "Kriteria berhasil diperbarui", html_content: html_content(@kriterium) }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan", html_content: error_content(@kriterium) }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /kriteria/1 or /kriteria/1.json
  def destroy
    @kriterium.destroy

    respond_to do |format|
      format.html { redirect_to kriteria_url, notice: "Kriterium was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def klass
    Object.const_get params[:controller].classify
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_kriterium
    @kriterium = Kriterium.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def kriterium_params
    params.require(klass.name.underscore.to_sym)
          .permit(:kriteria, :poin_max, :poin_min, :keterangan, :tipe_kriteria, :type,
                  :kriteria_id)
  end

  def html_content(kriterium)
    render_to_string(partial: 'kriterium',
                     formats: 'html',
                     layout: false,
                     locals: { kriterium: kriterium })
  end

  def error_content(kriterium)
    render_to_string(partial: 'error',
                     formats: 'html',
                     layout: false,
                     locals: { kriterium: kriterium })
  end
end
