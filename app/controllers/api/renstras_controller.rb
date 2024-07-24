class Api::RenstrasController < ActionController::API
  respond_to :json

  # GET /api/renstras or /api/renstras.json
  def index
    @kode_opd = params[:kode_opd]
    @tahun = params[:tahun]
    periode = params[:periode].split('-')
    @tahun_awal = periode[0].to_i
    @tahun_akhir = periode[-1].to_i
    @periode = (@tahun_awal..@tahun_akhir)
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    program_renstra = @opd.program_renstra

    program_kegiatan_by_urusans = program_renstra.group_by do |prg|
      [prg.kode_urusan, prg.nama_urusan]
    end
    @program_kegiatans = program_kegiatan_by_urusans.transform_values do |prg_v1|
      prg_v1.group_by { |prg| [prg.kode_bidang_urusan, prg.nama_bidang_urusan] }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_api_renstra
    @kode_unik_opd = params[:kode_opd]
    @tahun = params[:tahun]
  end

  # Only allow a list of trusted parameters through.
  def api_renstra_params
    params.fetch(:api_renstra, {})
  end

  def renstra_params
    params.require(:program_kegiatan)
          .permit(:nama_subkegiatan, :tahun, :target_subkegiatan, :indikator_subkegiatan)
  end

  def indikator_params
    params.require(:renstra).permit(indikator: %i[indikator tahun satuan kode jenis sub_jenis target pagu keterangan
                                                  kode_opd kode_indikator realisasi realisasi_pagu])
  end
end
