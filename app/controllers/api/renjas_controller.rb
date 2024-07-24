class Api::RenjasController < ActionController::API
  respond_to :json

  before_action :required_params

  def rankir
    @opd = Opd.find_by!(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd

    renja = RenjaService.new(kode_opd: @kode_opd, tahun: @tahun, jenis: 'rankir')
    @program_kegiatans = renja.program_kegiatan_renja
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: "Opd tidak ditemukan" },
           status: :not_found
  end

  def rankir_program
    @opd = Opd.find_by!(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    service = RenjaService.new(kode_opd: @kode_opd,
                               tahun: @tahun,
                               jenis: 'rankir')

    @subkegiatans = service.subkegiatan_renja
    @programs = service.program_renja
  end

  def rankir_kegiatan
    @opd = Opd.find_by!(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    service = RenjaService.new(kode_opd: @kode_opd,
                               tahun: @tahun,
                               jenis: 'rankir')

    @subkegiatans = service.subkegiatan_renja
    @kegiatans = service.kegiatan_renja
  end

  def rankir_subkegiatan
    @opd = Opd.find_by!(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    service = RenjaService.new(kode_opd: @kode_opd,
                               tahun: @tahun,
                               jenis: 'rankir')

    @subkegiatans = service.subkegiatan_renja
  end

  private

  def required_params
    @kode_opd = params[:kode_opd]
    @tahun = params[:tahun]
  end
end
