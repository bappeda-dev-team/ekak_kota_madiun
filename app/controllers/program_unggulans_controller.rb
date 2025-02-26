### USE THIS AS A BASE TO FILTER PERIODE AND DEFAULT GENERATE
class ProgramUnggulansController < ApplicationController
  before_action :set_program_unggulan, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /program_unggulans or /program_unggulans.json
  def index
    @lembaga_id = cookies[:lembaga_id]
    @tahun = cookies[:tahun]
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun_rpjmd(tahun_bener).first

    @periode = Periode.find_tahun(tahun_bener) if @periode.nil?
    @tahun_awal = @periode.tahun_awal
    @tahun_akhir = @periode.tahun_akhir

    selected_id = params[:selected]

    @program_unggulans = if selected_id.present? && request.format.json?
                           ProgramUnggulan.where(tahun_awal: @tahun_awal,
                                                 tahun_akhir: @tahun_akhir,
                                                 lembaga_id: @lembaga_id,
                                                 asta_karya: selected_id)
                         else
                           ProgramUnggulan.where(tahun_awal: @tahun_awal, tahun_akhir: @tahun_akhir,
                                                 lembaga_id: @lembaga_id)
                         end
  end

  def filter
    @lembaga_id = cookies[:lembaga_id]
    @periode = Periode.find(params[:periode])
    @tahun_awal = @periode.tahun_awal
    @tahun_akhir = @periode.tahun_akhir

    @program_unggulans = ProgramUnggulan.where(tahun_awal: @tahun_awal,
                                               tahun_akhir: @tahun_akhir,
                                               lembaga_id: @lembaga_id)
    render partial: 'program_unggulans/asta_karya'
  end

  # GET /program_unggulans/1 or /program_unggulans/1.json
  def show; end

  # GET /program_unggulans/new
  def new
    lembaga = Lembaga.find(cookies[:lembaga_id])
    @periode = Periode.find(params[:periode])

    # default urutan
    urutan = ProgramUnggulan.where(lembaga_id: lembaga.id,
                                   tahun_awal: @periode.tahun_awal,
                                   tahun_akhir: @periode.tahun_akhir)
                            .count
    urutan += 1
    @program_unggulan = ProgramUnggulan.new(lembaga_id: lembaga.id,
                                            urutan: urutan)
  end

  # GET /program_unggulans/1/edit
  def edit
    @periode = Periode.find_by(tahun_awal: @program_unggulan.tahun_awal,
                               tahun_akhir: @program_unggulan.tahun_akhir,
                               jenis_periode: 'RPJMD')
  end

  # POST /program_unggulans or /program_unggulans.json
  def create
    @program_unggulan = ProgramUnggulan.new(program_unggulan_params)
    @periode = Periode.find_by(tahun_awal: @program_unggulan.tahun_awal,
                               tahun_akhir: @program_unggulan.tahun_akhir,
                               jenis_periode: 'RPJMD')

    if @program_unggulan.save
      render json: { resText: 'Asta Karya ditambahkan',
                     html_content: html_content({ program_unggulan: @program_unggulan },
                                                partial: 'program_unggulans/program_unggulan') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: html_content({ program_unggulan: @program_unggulan },
                                                partial: 'program_unggulans/form') }
        .to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /program_unggulans/1 or /program_unggulans/1.json
  def update
    @periode = Periode.find_tahun(@program_unggulan.tahun_awal)
    if @program_unggulan.update(program_unggulan_params)
      render json: { resText: 'Perubahan disimpan',
                     html_content: html_content({ program_unggulan: @program_unggulan },
                                                partial: 'program_unggulans/program_unggulan') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: html_content({ program_unggulan: @program_unggulan },
                                                partial: 'program_unggulans/form') }
        .to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /program_unggulans/1 or /program_unggulans/1.json
  def destroy
    @program_unggulan.destroy

    render json: { resText: "Asta Karya Dihapus" }.to_json, status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_program_unggulan
    @program_unggulan = ProgramUnggulan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def program_unggulan_params
    params.require(:program_unggulan).permit(:asta_karya, :tahun_awal, :tahun_akhir, :urutan, :keterangan,
                                             :lembaga_id)
  end
end
