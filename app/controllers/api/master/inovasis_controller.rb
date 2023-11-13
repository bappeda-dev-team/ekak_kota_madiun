module Api
  module Master
    class InovasisController < ActionController::API
      before_action :set_inovasi, only: %i[show edit update destroy]

      # GET /inovasis or /inovasis.json
      def index
        @tahun = params[:tahun]
        kode_unik_opd = params[:kode_opd]
        opd = Opd.find_by(kode_unik_opd: kode_unik_opd)
        @inovasis = Inovasi.includes(:user).where(user: { kode_opd: opd.kode_opd })
      end

      def usulan_inisiatif
        @inovasis = Inovasi.where(nip_asn: current_user.nik)
        render 'user_inisiatif'
      end

      # GET /inovasis/1 or /inovasis/1.json
      def show; end

      # GET /inovasis/new
      def new
        user = current_user.nik
        opd = Opd.find_by_kode_unik_opd(cookies[:opd])
        tahun = cookies[:tahun]
        @inovasi = Inovasi.new(tahun: tahun, nip_asn: user, opd: opd,
                               is_active: true, status: 'disetujui')
        render layout: false
      end

      # GET /inovasis/1/edit
      def edit
        render layout: false
      end

      # POST /inovasis or /inovasis.json
      def create
        form_params = inovasi_params.merge(is_active: true, status: 'disetujui')
        @inovasi = Inovasi.new(form_params)

        if @inovasi.save
          render json: { resText: "Entri Inisiatif ditambahkan",
                         html_content: html_content({ inovasi: @inovasi },
                                                    partial: 'inovasis/inovasi') }.to_json,
                 status: :ok
        else
          render json: { resText: "Terjadi kesalahan",
                         html_content: error_content({ inovasi: @inovasi },
                                                     partial: 'inovasis/form') }.to_json,
                 status: :unprocessable_entity
        end
      end

      # PATCH/PUT /inovasis/1 or /inovasis/1.json
      def update
        if @inovasi.update(inovasi_params)
          render json: { resText: "Perubahan tersimpan",
                         html_content: html_content({ inovasi: @inovasi },
                                                    partial: 'inovasis/inovasi') }.to_json,
                 status: :ok
        else
          render json: { resText: "Terjadi kesalahan",
                         html_content: error_content({ inovasi: @inovasi },
                                                     partial: 'inovasis/form') }.to_json,
                 status: :unprocessable_entity
        end
      end

      # DELETE /inovasis/1 or /inovasis/1.json
      def destroy
        @inovasi.destroy
        render json: { resText: "Usulan inisiatif Dihapus", result: true }
      end

      def toggle_is_active
        @inovasi = Inovasi.find(params[:id])
        respond_to do |format|
          if @inovasi.update(status: 'disetujui')
            @inovasi.toggle! :is_active
            flash.now[:success] = 'Usulan diaktifkan'
            format.js { render 'toggle_is_active' }
          else
            flash.now[:alert] = 'Gagal Mengaktifkan'
            format.js { :unprocessable_entity }
          end
        end
      end

      def setujui_usulan_di_sasaran
        @inovasi = Inovasi.find(params[:id])
        respond_to do |format|
          if @inovasi.update(status: 'disetujui')
            @inovasi.toggle! :is_active
            flash.now[:success] = 'Usulan disetujui'
            format.js { render 'toggle_is_active' }
          else
            flash.now[:alert] = 'Gagal Mengaktifkan'
            format.js { :unprocessable_entity }
          end
        end
      end

      def inovasi_search
        param = params[:q] || ''
        @inovasis = Search::AllUsulan
                    .where(
                      "searchable_type = 'Inovasi' and sasaran_id is null and usulan ILIKE ?", "%#{param}%"
                    )
                    .where(searchable: Inovasi.where(nip_asn: current_user.nik))
                    .order(searchable_id: :desc)
                    .includes(:searchable)
                    .collect(&:searchable)
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_inovasi
        @inovasi = Inovasi.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def inovasi_params
        params.require(:inovasi).permit!
      end
    end
  end
end
