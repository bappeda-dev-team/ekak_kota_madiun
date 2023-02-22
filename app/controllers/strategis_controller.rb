class StrategisController < ApplicationController
  before_action :set_strategi, only: %i[show edit update destroy]

  # GET /strategis or /strategis.json
  def index
    @strategis = Strategi.all
  end

  # GET /strategis/1 or /strategis/1.json
  def show; end

  # GET /strategis/new
  def new
    @strategi = Strategi.new
    @nip = params[:nip]
    @role = params[:role]
    @strategi.build_sasaran.indikator_sasarans.build
    @usulan_isu = params[:usulan_isu]
  end

  # GET /strategis/1/edit
  def edit
    @nip = params[:nip]
    @role = params[:role]
    @usulan_isu = params[:usulan_isu]
    # @sasaran = @strategi.sasaran
    # @sasaran.indikator_sasarans.build
  end

  # POST /strategis or /strategis.json
  def create
    @strategi = Strategi.new(strategi_params)

    respond_to do |format|
      if @strategi.save
        format.html { redirect_to strategi_url(@strategi), notice: "Strategi was successfully created." }
        format.json { render :show, status: :created, location: @strategi }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @strategi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /strategis/1 or /strategis/1.json
  def update
    @role = params[:strategi][:role]
    respond_to do |format|
      if @strategi.update(strategi_params)
        if @role == "eselon_2"
          format.html { redirect_to opd_pohon_kinerja_index_path, success: "Sukses" }
        else
          format.html { redirect_to asn_pohon_kinerja_index_path, success: "Sukses" }
        end
        format.json { render :show, status: :ok, location: @strategi }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @strategi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strategis/1 or /strategis/1.json
  def destroy
    @strategi.destroy

    respond_to do |format|
      format.html { redirect_to strategis_url, notice: "Strategi was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def bagikan_pokin
    # TODO: guard strategi, jika tidak ketemu, maka abal abal
    @strategi = Strategi.find(params[:id])
    @strategi_atasan_id = @strategi.id
    @role = params[:role]
    @pohon_id = @strategi.pohon_id
    @opd = current_user.opd
    @bawahans = @opd.users.with_role(@role.to_sym)
    render partial: "form_bagikan_pokin"
  end

  # membuat strategi kosong dengan nip dan strategi_ref_id
  def pilih_asn
    @strategi_atasan_id = params[:id]
    @role = params[:role]
    @nip = params[:nip]
    @pohon_id = params[:pohon_id].to_i
    @strategi = Strategi.new(strategi_ref_id: @strategi_atasan_id,
                             nip_asn: @nip,
                             role: @role,
                             pohon_id: @pohon_id)
    respond_to do |format|
      if @strategi.save
        if @role == "eselon_3"
          format.html { redirect_to opd_pohon_kinerja_index_path, success: "Strategi dibagikan" }
        else
          format.html { redirect_to asn_pohon_kinerja_index_path, success: "Strategi dibagikan" }
        end
      else
        format.html { redirect_to asn_pohon_kinerja_index_path, error: "Terjadi Kesalahan" }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_strategi
    @strategi = Strategi.find(params[:id])
    # @sasaran = @strategi.build_sasaran.indikator_sasarans.build
  end

  # Only allow a list of trusted parameters through.
  def strategi_params
    params.require(:strategi).permit(:strategi, :tahun, :sasaran_id, :strategi_ref_id, :nip_asn, :role, :pohon_id,
                                     sasaran_attributes: [:sasaran_kinerja, :nip_asn, :strategi_id,
                                                          { indikator_sasarans_attributes: %i[id indikator_kinerja
                                                                                              sasaran_id
                                                                                              aspek target satuan
                                                                                              _destroy] }])
  end
end
