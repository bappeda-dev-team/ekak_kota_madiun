class IndikatorsUsersController < ApplicationController
  before_action :set_indikators_user, only: %i[show edit update destroy]
  before_action :set_tahun_opd
  layout false, only: %i[new edit]

  # GET /indikators_users or /indikators_users.json
  def index
    @indikators_users = IndikatorsUser.all
  end

  def indikator_by_jenis
    search = params[:q] || ''
    jenis = params[:jenis]
    sub_jenis = params[:sub_jenis]
    kode_opd = params[:kode_opd]

    indikators = Indikator.where(jenis: jenis,
                                 sub_jenis: sub_jenis,
                                 tahun: @tahun,
                                 kode_opd: kode_opd)
                          .where('indikator ILIKE ?', "%#{search}%")
    results = indikators.map { |ind| { id: ind.id, text: ind.jenis_sub_jenis } }

    render json: { results: results }.to_json
  end

  def pelaksana_indikator
    param = params[:q] || ''
    role = params[:role]
    asn_list = @opd.users.where('nama ILIKE ?', "%#{param}%")
    pelaksana = asn_list.with_any_role(role)
    pelaksana.map! { |user| { id: user.id, text: user.nama_nip } }
    render json: { results: pelaksana }.to_json
  end

  # GET /indikators_users/1 or /indikators_users/1.json
  def show; end

  # GET /indikators_users/new
  def new
    @dom_id = params[:dom_id]
    @role = params[:role]
    @roles = [@role]
    if @role == 'eselon_3'
      @roles.push('eselon_2b')
    elsif @role == 'eselon_4'
      @roles.push('staff')
    else
      @roles
    end
    @indikators_user = IndikatorsUser.new
  end

  # GET /indikators_users/1/edit
  def edit; end

  # POST /indikators_users or /indikators_users.json
  def create
    indikators = params[:indikators_user][:indikator_id].compact_blank
    user = params[:indikators_user][:user_id]

    indikator_users = []
    indikators.each do |ind|
      ind_user = IndikatorsUser.create(indikator_id: ind, user_id: user)
      indikator_users << ind_user
    end

    if indikator_users.any?
      render json: { resText: "Pelaksana Indikator diperbarui" }.to_json,
             status: :ok

    else
      render json: { resText: "terjadi kesalahan", errors: error_content }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /indikators_users/1 or /indikators_users/1.json
  def update
    respond_to do |format|
      if @indikators_user.update(indikators_user_params)
        format.html do
          redirect_to indikators_user_url(@indikators_user), notice: "Indikators user was successfully updated."
        end
        format.json { render :show, status: :ok, location: @indikators_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @indikators_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indikators_users/1 or /indikators_users/1.json
  def destroy
    @indikators_user.destroy

    respond_to do |format|
      format.html { redirect_to indikators_users_url, notice: "Indikators user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_indikators_user
    @indikators_user = IndikatorsUser.find(params[:id])
  end

  def set_tahun_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
  end

  # Only allow a list of trusted parameters through.
  def indikators_user_params
    params.require(:indikators_user).permit(:indikator_id, :user_id)
  end

  def html_content(pohon)
    render_to_string(partial: 'pohon_kinerja_opds/item_cascading',
                     formats: 'html',
                     layout: false,
                     locals: { pohon: pohon })
  end

  def error_content
    render_to_string(partial: 'form',
                     formats: 'html',
                     layout: false,
                     locals: { pelaksana: @pelaksana })
  end
end
