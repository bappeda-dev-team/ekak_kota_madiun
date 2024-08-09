class SpbesController < ApplicationController
  before_action :set_program, only: %i[edit new]
  before_action :set_spbe, only: %i[edit show update destroy]
  before_action :set_default_attr

  def index
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @spbes = Spbe.all.group_by(&:program_kegiatan)
    @programs = @opd.program_kegiatans.programs
    # @spbes = @programs.to_h { |prg| [prg, prg.spbes] }
  end

  def index_opd
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @spbes_external = Spbe.by_opd_tujuan(@kode_opd).group_by(&:program_kegiatan)
    @programs = @opd.program_kegiatans.programs
    @spbes = @programs.to_h { |prg| [prg, prg.spbes.by_opd(@kode_opd)] }
  end

  def excel_opd
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @timestamp = Time.now.to_formatted_s(:number)
    @filename = "SPBE #{@nama_opd} #{@tahun} - #{@timestamp}.xlsx"

    @programs = @opd.program_kegiatans.programs
    @spbes = @programs.to_h { |prg| [prg, prg.spbes.by_opd(@kode_opd)] }

    if @opd.id == 145
      render xlsx: "spbe_setda_excel", filename: @filename
    else

      render xlsx: "spbe_excel_opd", filename: @filename
    end
  end

  def new
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @spbe = Spbe.new
    @spbe.spbe_rincians.build
  end

  def edit
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def edit_operational_opd
    @program = ProgramKegiatan.find(params[:program_id])
    @spbe_rincian = SpbeRincian.find(params[:id])
    @spbe = @spbe_rincian.spbe
    @opd = @spbe_rincian.opd
  end

  def create
    @program = ProgramKegiatan.find(spbe_params[:program_kegiatan_id])
    @spbe = Spbe.new(spbe_params)

    redirect_routes = index_opd_spbes_path

    respond_to do |format|
      if @spbe.save
        format.html { redirect_to redirect_routes, success: "Entri SPBE tersimpan" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    redirect_routes = index_opd_spbes_path
    respond_to do |format|
      if @spbe.update(spbe_params)
        format.html { redirect_to redirect_routes, success: "Entri SPBE diperbarui" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    redirect_routes = current_user.has_role?(:super_admin) ? spbes_path : index_opd_spbes_path
    jenis_pelayanan = @spbe.jenis_pelayanan
    @spbe.destroy
    respond_to do |format|
      format.html { redirect_to redirect_routes, success: "Entri SPBE '#{jenis_pelayanan}' Dihapus" }
    end
  end

  private

  def set_spbe
    @spbe = Spbe.find(params[:id])
  end

  def set_program
    @program = ProgramKegiatan.find(params[:program_id])
  end

  def set_default_attr
    @user = current_user
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun] || Date.current.year
  end

  def spbe_params
    params.require(:spbe).permit(:jenis_pelayanan, :nama_aplikasi,
                                 :strategi_ref_id, :kode_program,
                                 :kode_opd, :program_kegiatan_id,
                                 :terintegrasi_dengan,
                                 :output_aplikasi,
                                 :output_data,
                                 :output_informasi,
                                 :output_cetak,
                                 :pemilik_aplikasi,
                                 spbe_rincians_attributes: %i[id detail_sasaran_kinerja
                                                              detail_kebutuhan
                                                              domain_spbe
                                                              aspek_spbe
                                                              subdomain_spbe
                                                              keterangan id_rencana kebutuhan_spbe
                                                              internal_external tahun_awal tahun_akhir
                                                              kode_opd kode_program _destroy])
  end
end
