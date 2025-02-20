class StrategisController < ApplicationController
  before_action :set_strategi, only: %i[show edit update destroy renaksi]
  # before_action :strategi_pohon_atasan, only: %i[new edit]

  # GET /strategis or /strategis.json
  def index
    @strategis = Strategi.all
  end

  def rekap_strategi
    @tahun = params[:tahun]
    @nip_asn = params[:nip_asn]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd) || current_user.opd
    @user = User.find_by(nik: @nip_asn) || current_user
    @strategis = @user.strategis.where('tahun ILIKE ?', "%#{@tahun}%")
  end

  # GET /strategis/1 or /strategis/1.json
  def show
    render partial: 'show_update', locals: { strategi: @strategi }
  end

  # GET /strategis/new
  def new
    @tahun = cookies[:tahun] || Date.current.year
    @opd = current_user.opd
    @opd_id = @opd.id
    @strategi = Strategi.new
    @nip = params[:nip] || current_user.nik
    @role = params[:role] || current_user.eselon_user
    @usulan_isu = params[:usulan_isu]
    @strategis = StrategiPohon.where(tahun: @tahun, role: @role)
    @sasaran = @strategi.build_sasaran
    @sasaran.indikator_sasarans.build
    @is_new = true
    # strategi_pohon_atasan(@nip)
  end

  # GET /strategis/1/edit
  def edit
    @tahun = cookies[:tahun] || Date.current.year
    @opd = current_user.opd
    @opd_id = @opd.id
    @nip = params[:nip]
    @role = params[:role]
    @usulan_isu = params[:usulan_isu]
    @strategis = StrategiPohon.where(tahun: @tahun, role: @role)
    @sasaran = @strategi.sasaran.nil? ? @strategi.build_sasaran : @strategi.sasaran
    @is_new = false
    # strategi_pohon_atasan(@nip)
  end

  # POST /strategis or /strategis.json
  def create
    @role = strategi_params[:role]
    @nip = strategi_params[:nip_asn]
    @opd_id = strategi_params[:opd_id]
    @strategi_tulisan = StrategiPohon.find(strategi_params[:linked_with])
    strategi_parameter = strategi_params
    strategi_parameter[:strategi] = @strategi_tulisan.strategi
    @strategi = Strategi.new(strategi_parameter)
    @strategi.sasaran.tahun = strategi_params[:tahun]

    respond_to do |format|
      if @strategi.save
        if current_user.has_role?(:admin)
          format.html { redirect_to opd_pohon_kinerja_index_path, success: "Sukses" }
        else
          format.html { redirect_to asn_pohon_kinerja_index_path, success: "Sukses" }
        end
        # format.html { redirect_to strategi_url(@strategi), notice: "Strategi was successfully created." }
        # format.json { render :show, status: :created, location: @strategi }
      else
        @tahun = cookies[:tahun] || Date.current.year
        strategi_pohon_atasan(@nip)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @strategi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /strategis/1 or /strategis/1.json
  def update
    @role = params[:strategi][:role]
    # @strategi.sasaran.tahun = strategi_parameter[:tahun]
    @nip = strategi_params[:nip_asn]
    @opd_id = strategi_params[:opd_id]
    respond_to do |format|
      if @strategi.update(strategi_params)
        if current_user.has_role?(:admin)
          format.html { redirect_to opd_pohon_kinerja_index_path, success: "Sukses" }
        else
          format.html { redirect_to asn_pohon_kinerja_index_path, success: "Sukses" }
        end
        format.json { render :show, status: :ok, location: @strategi }
      else
        @tahun = cookies[:tahun] || Date.current.year
        strategi_pohon_atasan(@nip)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @strategi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strategis/1 or /strategis/1.json
  def destroy
    @role = @strategi.role
    @strategi.destroy

    respond_to do |format|
      if current_user.has_role?(:admin)
        format.html { redirect_to opd_pohon_kinerja_index_path, success: "Sukses" }
      else
        format.html { redirect_to asn_pohon_kinerja_index_path, success: "Sukses" }
      end
      # format.html { redirect_to strategis_url, notice: "Strategi was successfully destroyed." }
      # format.json { head :no_content }
    end
  end

  def bagikan_pokin
    # TODO: guard strategi, jika tidak ketemu, maka abal abal
    @strategi = Strategi.find(params[:id])
    @strategi_atasan_id = @strategi.id
    @role = params[:role]
    @pohon_id = @strategi.pohon_id
    @opd = current_user.opd
    # opd khusus dimana terdapat eselon_2b (dinkes, sekda, pendidikan)
    @bawahans = if [145,
                    122, 123].include?(@opd.id) && @role == 'eselon_3'
                  @opd.users.with_any_role(@role.to_sym,
                                           :eselon_2b)
                else
                  @opd.users.with_role(@role.to_sym)
                end
    render partial: "form_bagikan_pokin"
  end

  # membuat strategi kosong dengan nip dan strategi_ref_id
  def pilih_asn
    @strategi_atasan_id = params[:id]
    strategi_atasan = Strategi.find(@strategi_atasan_id)
    @role = params[:role]
    @nip = params[:nip]
    @pohon_id = params[:pohon_id].to_i
    @tahun = cookies[:tahun]

    dibagikan = params[:dibagikan]
    tidak = params[:tidak_dibagikan]
    if tidak
      hapus_bagikan = dibagikan.nil? ? tidak : (tidak - dibagikan)
      hapus_bagikan.each do |hapus|
        strategi_atasan.strategi_bawahans.find(hapus).delete
      end
    end

    strategi_tray = []
    @nip&.each do |nip_asn|
      strategi_tray.push({ strategi_ref_id: @strategi_atasan_id,
                           nip_asn: nip_asn,
                           tahun: @tahun,
                           role: @role,
                           pohon_id: @pohon_id })
    end
    @strategi = Strategi.create(strategi_tray)
    @jumlah_strategi = strategi_atasan.strategi_bawahans.count
    render json: { resText: "Sukses membagikan", result: { data: { jumlah_strategi: @jumlah_strategi } } },
           status: :accepted
  end

  def list_strategi_asn
    @nip = params[:nip]
    @eselon = params[:role]
    @strategi = Strategi.find(params[:id])
    @list_strategi_asn = case @eselon
                         when 'eselon_2'
                           @strategi.strategi_eselon_tigas
                         when 'eselon_3'
                           @strategi.strategi_eselon_empats
                         else
                           @strategi.strategi_staffs
                         end
    @list_strategi_asn = @list_strategi_asn.where.not(nip_asn: "")
    render partial: 'list_strategi_asn'
  end

  def hapus_bagikan_ke_asn
    @strategi = Strategi.find(params[:id])
    dibagikan = params[:dibagikan]
    tidak = params[:tidak_dibagikan]
    hapus_bagikan = dibagikan.nil? ? tidak : (tidak - dibagikan)
    hapus_bagikan.each do |hapus|
      @strategi.strategi_eselon_empats.find(hapus).delete
    end
  end

  def strategi_pohon_atasan(nip)
    @isu_strategis_atasan = Strategi
                            .where("nip_asn = ? and tahun ILIKE ?", nip, "%#{@tahun}%")
                            .uniq(&:strategi_ref_id)
                            .collect do |str|
      [str.isu_strategis_disasar, str.strategi_ref_id]
    end
    @isu_strategis_pohon = Strategi
                           .where("nip_asn = ? and tahun ILIKE ?", nip, "%#{@tahun}%")
                           .uniq(&:pohon_id)
                           .collect do |str|
      [str.pohon.strategi_kota_isu_strategis, str.pohon_id]
    end
  end

  def renaksi
    sasaran = @strategi.sasaran
    @renaksi = sasaran.tahapans.pluck(:tahapan_kerja)
    render partial: 'strategis/renaksi'
  end

  # rubocop: disable Metrics
  def pokin_list
    query = params[:q] || ''
    tahun = cookies[:tahun]
    # user = current_user.id
    user = params[:user_id]
    # kode_unik_opd = cookies[:opd]
    # opd = Opd.find_by_kode_unik_opd(kode_unik_opd)
    # role = current_user.role_asn
    #
    user_search = Regexp.escape(query)
    @pohons = Pohon.where(tahun: tahun,
                          user_id: user,
                          pohonable_type: 'StrategiPohon')
                   .select { |p| p.pohonable.strategi =~ /#{user_search}/i }
                   .reject { |p| p.pohonable.nil? || p.role == 'deleted' || p.pohonable.role == 'deleted' || p.pohonable.strategi_dihapus? }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_strategi
    @strategi = Strategi.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def strategi_params
    strategi_parameter = params.require(:strategi)
                               .permit(:strategi, :tahun, :sasaran_id, :strategi_ref_id,
                                       :nip_asn, :role, :pohon_id, :opd_id,
                                       :linked_with,
                                       sasaran_attributes: [:sasaran_kinerja, :nip_asn, :strategi_id, :tahun,
                                                            :id_rencana, indikator_sasarans_params])
    tahun = strategi_parameter[:tahun]
    tahun_bener = /murni/.match?(tahun) ? tahun[/[^_]\d*/, 0] : tahun
    strategi_parameter[:tahun] = tahun_bener
    strategi_parameter[:sasaran_attributes][:tahun] = strategi_parameter[:tahun]
    strategi_parameter
  end

  def indikator_sasarans_params
    { indikator_sasarans_attributes: %i[id indikator_kinerja aspek target satuan _destroy] }
  end
end
