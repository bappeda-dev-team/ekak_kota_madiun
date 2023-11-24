class PindahPohonKinerjasController < ApplicationController
  before_action :set_pindah_pohon_kinerja, only: %i[show edit update destroy]
  layout false

  # GET /pindah_pohon_kinerjas or /pindah_pohon_kinerjas.json
  def index; end

  # GET /pindah_pohon_kinerjas/1 or /pindah_pohon_kinerjas/1.json
  def show
    @role_atasan = case params[:role]
                   when 'eselon_3', 'tactical_pohon_kota'
                     %w[eselon_2 strategi_pohon_kota]
                   when 'eselon_4', 'operational_pohon_kota'
                     %w[eselon_3 tactical_pohon_kota]
                   when 'staff'
                     'eselon_4'
                   else
                     ''
                   end
    role_strategi = @role_atasan[0]
    role_pohon = @role_atasan[-1]
    @list_atasan = Strategi.where(opd_id: @pindah_pohon_kinerja.opd_id,
                                  tahun: @pindah_pohon_kinerja.tahun,
                                  role: role_strategi)
    @pohons = Pohon.where(opd_id: @pindah_pohon_kinerja.opd_id,
                          tahun: @pindah_pohon_kinerja.tahun,
                          pohonable_type: 'Strategi',
                          role: role_pohon,
                          status: [nil, 'diterima', ''])
    @list_atasan += @pohons
    @list_atasan.compact_blank.uniq!
  end

  # GET /pindah_pohon_kinerjas/1/edit
  def edit
    # @roles = %w[Strategic Strategic-Kota Tactical Tactical-Kota Operational Operational-Kota]
    @roles = [%w[Strategic eselon_2], %w[Tactical eselon_3], %w[Operational eselon_4]]
    @role_atasan = params[:role_atasan]
    role_strategi = @role_atasan[0]
    role_pohon = @role_atasan[-1]
    @list_atasan = Strategi.where(opd_id: @pindah_pohon_kinerja.opd_id,
                                  tahun: @pindah_pohon_kinerja.tahun,
                                  role: role_strategi)
    @pohons = Pohon.where(opd_id: @pindah_pohon_kinerja.opd_id,
                          tahun: @pindah_pohon_kinerja.tahun,
                          pohonable_type: 'Strategi',
                          role: role_pohon)
    @list_atasan += @pohons
    @list_atasan.compact_blank.uniq!
  end

  # PATCH/PUT /pindah_pohon_kinerjas/1 or /pindah_pohon_kinerjas/1.json
  def update
    # NOTE: with strategi ref id containing another text ( role )
    # may causing an unexpected error from untested code
    # to debug find strategi_ref_id with pattern
    # id-role -> 2-strategi_pohon_kota

    new_parent = if pindah_pohon_kinerja_params[:strategi_ref_id].present?
                   pindah_pohon_kinerja_params[:strategi_ref_id].split('-')
                 else
                   [
                     '', ''
                   ]
                 end
    parent_id = new_parent[0]
    update_pohon = if pindah_pohon_kinerja_params[:level_pohon].present?
                     role = pindah_pohon_kinerja_params[:level_pohon]
                     @pindah_pohon_kinerja.update(role: role, strategi_ref_id: parent_id)
                   else
                     parent_role = new_parent[-1]

                     if parent_role.include?('kota')
                       role = case parent_role
                              when 'strategi_pohon_kota'
                                'tactical_pohon_kota'
                              when 'tactical_pohon_kota'
                                'operational_pohon_kota'
                              else
                                ''
                              end

                       @pindah_pohon_kinerja.create_new_pohon(role: role,
                                                              pohon_ref_id: parent_id)
                     end
                     @pindah_pohon_kinerja.update(strategi_ref_id: parent_id)
                   end

    return unless update_pohon

    redirect_to cascading_pohon_kinerja_opds_url,
                success: "Pindah pohon berhasil"
  end

  # DELETE /pindah_pohon_kinerjas/1 or /pindah_pohon_kinerjas/1.json
  def destroy
    @pindah_pohon_kinerja.destroy

    respond_to do |format|
      format.html { redirect_to pindah_pohon_kinerjas_url, notice: "Pindah pohon kinerja was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pindah_pohon_kinerja
    @pindah_pohon_kinerja = Strategi.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pindah_pohon_kinerja_params
    params.fetch(:strategi_pohon, {}).permit(:strategi_ref_id, :level_pohon)
  end
end
