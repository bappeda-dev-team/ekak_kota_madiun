class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit edit_profile update destroy edit_detail update_detail anggaran_sasaran]

  layout false, only: %i[new edit edit_profile]
  # GET /users or /users.json
  def index
    @users = User.all
  end

  def dropdown_user
    return unless current_user.has_role? :admin

    param = params[:q] || ""
    @users = current_user.opd.users.non_admin.where("nama ILIKE ?", "%#{param}%")
    respond_to do |f|
      f.json { render :index }
    end
  end

  def all; end

  def all_user
    @users = User.aktif
    render partial: 'users/all_user'
  end

  def khusus
    @users = User.khusus
  end

  def struktur
    @users = User.opd_by_role(params[:opd], 'asn')
  end

  def user_opd
    kode_opd = cookies[:opd] || ''
    opd = Opd.find_by(kode_unik_opd: kode_opd)
    return if opd.nil? || !current_user.admin?

    user_search = params[:q] || ''
    @users = opd.user_bidang_filter(user_search)
  end

  def user_search
    kode_opd = params[:kode_opd] || ''
    user_search = params[:q] || ''
    @users = User.where(kode_opd: kode_opd)
    return if user_search.empty?

    user_search.strip!
    @users = User.where(kode_opd: kode_opd)
                 .where('nama ILIKE ?', "%#{user_search}%")
                 .or(User.where('nik ILIKE ?', "%#{user_search}%"))
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  def user_admin
    @kode_unik_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_unik_opd)
    @tahun = cookies[:tahun]
    user_opd = @opd.users.non_admin
    user_jabatan = JabatanUser.where(kode_opd: @kode_unik_opd).includes(:user).flat_map(&:user)
    @users = user_opd + user_jabatan
  end

  def aktifkan_user
    @user = User.find_by(nik: params[:id])
    # @user.remove_role(:admin) if @user.has_role? :admin
    @user.remove_role :non_aktif if @user.has_role? :non_aktif
    @user.add_role(:asn) unless @user.has_role? :asn
    respond_to do |format|
      flash.now[:success] = "#{@user.nama} di aktifkan"
      format.js
    end
  end

  def nonaktifkan_user
    @user = User.find_by(nik: params[:id])
    # @user.remove_role(:admin) if @user.has_role? :admin
    @user.remove_role(:asn) if @user.has_role? :asn
    @user.add_role(:non_aktif) unless @user.has_role? :non_aktif
    # @user.has_role?(:non_aktif) ? @user.remove_role(:non_aktif) : @user.add_role(:non_aktif)
    respond_to do |format|
      flash.now[:success] = "#{@user.nama} di nonaktifkan"
      format.js
    end
  end

  def hapus_asn
    @user = User.find_by(nik: params[:id])
    @user.remove_role(:asn) if @user.has_role? :asn
    respond_to do |format|
      flash.now[:success] = "Berhasil hapus role"
      format.js { render 'nonaktifkan_user' }
    end
  end

  def nonaktifkan_semua_user
    opd = params[:opd]
    nama_opd = Opd.find_by(kode_opd: opd).nama_opd
    @asn_aktif = User.opd_by_role(opd, 'asn')
    @user_empty = User.where(kode_opd: opd).without_role(:asn).without_role(:non_aktif).without_role(:admin)
    @users = @asn_aktif + @user_empty
    @users.each { |asn| asn.nonaktifkan_user }
    respond_to do |format|
      flash.now[:success] = "Seluruh Pegawai #{nama_opd} di nonaktifkan"
      format.js { render 'shared/_notifikasi_simple' }
    end
  end

  # GET /users/1/edit
  def edit; end

  def edit_detail
    render partial: 'form_detail', locals: { user: @user }
  end

  def edit_profile; end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    roles = params[:user][:role].compact_blank
    if @user.save
      if roles.present?
        roles.each do |role|
          @user.add_role role.to_sym
        end
      end
      render json: { resText: "User berhasil dibuat.",
                     html_content: html_content({ user: @user },
                                                partial: 'users/user') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ user: @user },
                                                 partial: 'users/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if @user.update(user_params)
      render json: { resText: "Data user diupdate.",
                     html_content: html_content({ user: @user },
                                                partial: 'users/user') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ user: @user },
                                                 partial: 'users/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  def update_detail
    if @user.update(user_detail_params)
      render json: { resText: "Detail user diperbarui",
                     html_content: html_content({ user: @user },
                                                partial: 'users/user') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ user: @user },
                                                 partial: 'users/form_detail') }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to adminusers_path, success: 'User dihapus.' }
      format.json { head :no_content }
    end
  end

  def set_role
    @user = User.find(params[:id])
    @dom_id = params[:dom_id]
    @opd = @user.opd
    @roles = Role.where(name: %w[eselon_2 eselon_3 eselon_4 staff reviewer_kak]).pluck(:name)
    @roles.insert(1, 'eselon_2b') if [145, 122, 123].include?(@opd.id)
    render partial: "form_peran"
  end

  def set_role_khusus
    @user = User.find(params[:id])
    @dom_id = params[:dom_id]
    @opd = @user.opd
    @roles = Role.pluck(:name)
    render partial: "form_peran"
  end

  def add_role
    @user = User.find(params[:id])
    @dom_id = params[:dom_id]
    target_role = params[:role]
    remove_role = params[:uncheck]
    checked_role = target_role.nil? ? [] : target_role & remove_role
    unchecked_role = target_role.nil? ? remove_role : (remove_role - target_role)
    if checked_role.any?
      checked_role.each do |role_add|
        @user.add_role(role_add)
        @user.add_role(:asn)
      end
    end
    if unchecked_role.any?
      unchecked_role.each do |role_rem|
        @user.remove_role(role_rem)
      end
    end
    render json: { resText: "Data disimpan", result: { roles: @user.roles.pluck(:name), target: @dom_id } },
           status: :accepted
  end

  def list_all
    keyword = params[:keyword]
    @users = if keyword && keyword.length > 3
               User.where("nama ILIKE ?", "%#{keyword}%")
                   .or(User.where("nik ILIKE ?", "%#{keyword}%"))
                   .or(User.where("jabatan ILIKE ?", "%#{keyword}%"))
             else
               []
             end
  end

  def edit_nip
    @user = User.find(params[:id])
    @nip = @user.nik
    render partial: "form_nip"
  end

  def update_nip
    @user = User.find(params[:id])
    @nip = params[:nip]
    @user.nip_sebelum = @user.nik
    @user.nulify_sasaran(@user.nik)
    @user.nulify_strategi(@user.nik)
    @user.nik = @nip
    @user.save
    @user.update_sasaran
    @user.update_strategi
    render json: { resText: "Data disimpan", result: { data: @nip } },
           status: :accepted
  end

  def anggaran_sasaran
    @tahun = cookies[:tahun] || Date.today.year
    @sasarans = @user.subkegiatan_sudah_lengkap(@tahun)
  end

  def mutasi_asn
    @user = User.find(params[:id])
    @tahun = cookies[:tahun]
    @tahun_asli = @tahun.gsub('_perubahan', '')
    render partial: 'form_mutasi', locals: { user: @user }
  end

  def update_password
    @user = User.find(params[:id])
    render partial: 'form_password', locals: { user: @user }
  end

  def ganti_password
    @user = User.find(params[:id])
    password = user_params[:password]
    confirm_password = user_params[:password_confirmation]

    if password == confirm_password
      @user.update(password: user_params[:password])
      render json: { resText: "Password diperbarui",
                     html_content: html_content({ user: @user },
                                                partial: 'users/user') }.to_json,
             status: :ok
    else
      @error = 'Password tidak sesuai'
      render json: { resText: "Password tidak sesuai",
                     html_content: error_content({ user: @user },
                                                 partial: 'users/form_password') }.to_json,
             status: :unprocessable_entity
    end
  end

  def reset_password
    @user = User.find(params[:id])
    default = ExternalUrl.find_by(aplikasi: 'E-KAK', username: 'default')
    password = default.password
    confirm_password = default.password

    if password == confirm_password
      password_escaped = password.sub(/.*/, "[redacted]")

      @user.update(password: password_escaped)
      render json: { resText: "Password diperbarui",
                     html_content: html_content({ user: @user },
                                                partial: 'users/user') }.to_json,
             status: :ok
    else
      @error = 'Password tidak sesuai'
      render json: { resText: "Password tidak sesuai",
                     html_content: error_content({ user: @user },
                                                 partial: 'users/form_password') }.to_json,
             status: :unprocessable_entity
    end
  end

  def update_jabatan # rubocop:disable Metrics
    @tahun_asli = params[:user][:tahun]
    @kode_opd = params[:user][:kode_opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @user = User.find(params[:id])
    # @bulan = DateTime.current.month.to_i
    @bulan = params[:user][:bulan]
    @jabatan = params[:user][:jabatan]
    @status_jabatan = params[:user][:status_jabatan]
    @jabatan_user = JabatanUser.new(nip_asn: @user.nik,
                                    kode_opd: @kode_opd, id_jabatan: @jabatan,
                                    status: @status_jabatan,
                                    tahun: @tahun_asli, bulan: @bulan)
    if @jabatan_user.save
      @user.update(opd: @opd) if params[:pindah_opd]
      @user.after_pindah if params[:hapus_sasaran]
      render json: { resText: "Jabatan diperbarui",
                     html_content: html_content({ user: @user },
                                                partial: 'users/user') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ user: @user },
                                                 partial: 'users/form_mutasi') }.to_json,
             status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_dropdown
    @opds = Opd.all
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:nama, :nik, :password, :kode_opd, :email, :lembaga_id, :password_confirmation,
                                 :pindah_opd, :hapus_sasaran, :status_jabatan)
  end

  def user_detail_params
    if params[:kepala]
      params.require(:kepala).permit(:nama, :nama_bidang, :kode_opd, :jabatan)
    elsif params[:atasan]
      params.require(:atasan).permit(:nama, :nama_bidang, :kode_opd, :jabatan)
    else
      params.require(:user).permit(:nama, :nama_bidang, :kode_opd, :jabatan)
    end
  end
end
