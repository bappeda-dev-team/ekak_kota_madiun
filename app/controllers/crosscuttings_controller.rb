class CrosscuttingsController < ApplicationController
  before_action :set_crosscutting, only: %i[show edit update destroy]
  before_action :set_tahun_opd

  layout false

  # GET /crosscuttings or /crosscuttings.json
  def index; end

  # GET /crosscuttings/1 or /crosscuttings/1.json
  def show
    @crosscuttings = @crosscutting.external
  end

  # GET /crosscuttings/1/edit
  def edit; end

  def edit_keterangan
    @pohon = Pohon.find(params[:id])
  end

  def update_keterangan
    @pohon = Pohon.find(params[:id])
    keterangan = params[:keterangan]

    if @pohon.update(keterangan: keterangan)
      render json: { resText: 'Perubahan data disimpan',
                     html_content: html_content({ crosscutting: @pohon },
                                                partial: 'crosscuttings/crosscutting') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ pohon: @pohon  },
                                                 partial: 'crosscuttings/form_keterangan') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /crosscuttings/1 or /crosscuttings/1.json
  def update
    check = params[:check]
    uncheck = params[:uncheck]
    keterangan = params[:keterangan]
    hapus_cross = check.nil? ? uncheck : (uncheck - check)
    pohons = Pohon.where(id: hapus_cross)

    pohons.update_all(
      pohonable_id: '',
      pohonable_type: '',
      role: 'opd-batal',
      keterangan: keterangan,
      status: 'batal-crosscutting',
      metadata: {
        dibatalkan_by: current_user.id,
        dibatalkan_at: DateTime.current
      }
    )
    list_pohon_baru = []
    opd_list = params[:opd_list].compact_blank
    opd_list.each do |kode_opd|
      opd = Opd.find_by(kode_unik_opd: kode_opd)
      list_pohon_baru.push({ opd_id: opd.id,
                             tahun: @tahun,
                             role: 'opd',
                             pohonable_id: @crosscutting.id,
                             pohonable_type: 'StrategiPohon',
                             keterangan: keterangan,
                             status: 'crosscutting',
                             strategi_id: @crosscutting.id,
                             metadata: {
                               dibagikan_by: current_user.id,
                               dibagikan_at: DateTime.current
                             } })
    end

    cross_baru = Pohon.create(list_pohon_baru) if list_pohon_baru.any?

    if pohons.any? || cross_baru
      strategi = @crosscutting.strategi
      render json: { resText: "Crosscutting berhasil diperbarui",
                     html_content: html_content({ pohon: strategi },
                                                partial: 'pohon_kinerja_opds/item_pohon') }.to_json,
             status: :ok
    else
      render json: { resText: "Tidak ada perubahan",
                     html_content: html_content({ pohon: @crosscutting.strategi },
                                                 partial: 'pohon_kinerja_opds/item_pohon') }.to_json,
             status: :ok
    end
  end

  # def html_content(pohon)
  #   render_to_string(partial: 'pohon_kinerja_opds/item_pohon',
  #                    formats: 'html',
  #                    layout: false,
  #                    locals: { pohon: pohon })
  # end

  # def error_content
  #   render_to_string(partial: 'form',
  #                    formats: 'html',
  #                    layout: false,
  #                    locals: { crosscutting: @crosscutting })
  # end

  private

  def set_tahun_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_crosscutting
    @crosscutting = Crosscutting.new(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def crosscutting_params
    params.require(:crosscutting).permit(:internal_external, :opd_list, :keterangan)
  end
end
