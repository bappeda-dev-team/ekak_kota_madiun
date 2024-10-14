class SpbesController < ApplicationController
  before_action :set_program, only: %i[edit new]
  before_action :set_spbe, only: %i[edit show update destroy]
  before_action :set_default_attr

  def index
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @spbes = Spbe.all.group_by(&:program_kegiatan)
  end

  def index_opd
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @domain = params[:domain]
    spbe = if @domain.present? && @domain != 'all'
             Spbe.includes(:spbe_rincians).where(spbe_rincians: { domain_spbe: @domain })
           else
             Spbe.all
           end
    @spbes_external = spbe.by_opd_tujuan(@kode_opd).group_by(&:program_kegiatan)
    @spbes = spbe.by_opd(@kode_opd).group_by(&:program_kegiatan)
  end

  def cetak
    @domain = params[:domain]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    spbe = if @domain.present? && @domain != 'all'
             Spbe.includes(:spbe_rincians).where(spbe_rincians: { domain_spbe: @domain })
           else
             Spbe.all
           end
    spbe_internal = spbe.by_opd(@kode_opd).group_by(&:program_kegiatan)
    spbes_external = spbe.by_opd_tujuan(@kode_opd).group_by(&:program_kegiatan)
    @spbes = spbe_internal.merge(spbes_external)
    current_page = request.original_url

    @filename = "PETA_RENCANA_USULAN_APLIKASI_SPBE_#{@nama_opd}_#{@tahun}"
    respond_to do |format|
      format.pdf do
        pdf = SpbePdf.new(opd: @opd, tahun: @tahun, programs: @programs, spbes: @spbes, current_page: current_page,
                          domain: @domain)
        send_data(pdf.render, filename: @filename, type: 'application/pdf', disposition: :attachment)
      end
      format.xlsx do
        excel_file = if @opd.id == 145
                       "spbe_setda_excel"
                     else
                       "spbe_excel_opd"
                     end
        render xlsx: excel_file, filename: @filename, disposition: :attachment
      end
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
    @program = @spbe.program_kegiatan
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
                                 :strategi_id, :kode_program,
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
                                                              status_kebutuhan_spbe keterangan_kebutuhan_spbe
                                                              kondisi_sekarang
                                                              kode_opd kode_program _destroy])
  end
end
