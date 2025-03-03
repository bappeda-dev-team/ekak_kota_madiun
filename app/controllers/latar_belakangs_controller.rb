class LatarBelakangsController < ApplicationController
  before_action :set_latar_belakang, only: %i[show edit update destroy]
  layout false, only: %i[edit new]

  # GET /latar_belakangs or /latar_belakangs.json
  def index
    @latar_belakangs = LatarBelakang.all.with_rich_text_dasar_hukum.with_rich_text_gambaran_umum
  end

  # GET /latar_belakangs/1 or /latar_belakangs/1.json
  def show; end

  # GET /latar_belakangs/new
  def new
    @sasaran = Sasaran.find(params[:sasaran_id])
    @latar_belakang = LatarBelakang.new
  end

  # GET /latar_belakangs/1/edit
  def edit
    @sasaran = Sasaran.find(params[:sasaran_id])
  end

  # POST /latar_belakangs or /latar_belakangs.json
  def create
    @sasaran = Sasaran.find(params[:sasaran_id])
    @latar_belakang = @sasaran.latar_belakangs.build(latar_belakang_params)

    if @latar_belakang.save
      render json: { resText: "Data Gambaran Umum berhasil ditambahkan",
                     html_content: html_content({ sasaran: @sasaran,
                                                  gambaran_umum: @latar_belakang },
                                                partial: 'latar_belakangs/gambaran_umum_card') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran: @sasaran,
                                                   latar_belakang: @latar_belakang },
                                                 partial: 'latar_belakangs/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /latar_belakangs/1 or /latar_belakangs/1.json
  def update
    @sasaran = Sasaran.find(params[:sasaran_id])
    if @latar_belakang.update(latar_belakang_params)
      render json: { resText: "Data Gambaran Umum berhasil diupdate",
                     html_content: html_content({ sasaran: @sasaran,
                                                  gambaran_umum: @latar_belakang },
                                                partial: 'latar_belakangs/row_gambaran_umum_card') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran: @sasaran,
                                                   latar_belakang: @latar_belakang },
                                                 partial: 'latar_belakangs/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /latar_belakangs/1 or /latar_belakangs/1.json
  def destroy
    @latar_belakang.destroy

    render json: { resText: "Gambaran Umum dihapus." }.to_json,
           status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_latar_belakang
    @latar_belakang = LatarBelakang.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def latar_belakang_params
    params.require(:latar_belakang).permit!
  end
end
