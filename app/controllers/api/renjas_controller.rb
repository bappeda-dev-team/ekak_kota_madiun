class Api::RenjasController < ActionController::API
  respond_to :json

  def rankir
    @kode_opd = params[:kode_opd]
    @tahun = params[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd

    renja = RenjaService.new(kode_opd: @kode_opd, tahun: @tahun, jenis: 'rankir')
    @program_kegiatans = renja.program_kegiatan_renja
  end

end
