class KolabsController < ApplicationController
  before_action :set_kolab, only: %i[show edit update destroy]
  layout false, only: %i[show new edit]

  # GET /kolabs or /kolabs.json
  def index
    @kolabs = Kolab.all
  end

  # GET /kolabs/1 or /kolabs/1.json
  def show; end

  # GET /kolabs/new
  def new
    # khusus kolaborasi inisiatif walkot
    @kolab = Kolab.new(kolabable_type: params[:type],
                       kolabable_id: params[:id],
                       tahun: params[:tahun],
                       jenis: 'Dari-Kota',
                       status: 'diterima')
    @target = params[:target]
    @kode_opd = params[:kode_opd]
    @opd = Opd.unscoped.find_by(kode_unik_opd: @kode_opd)

    # TODO: break the chain
    # this makes unusable outside inovasi
    @inovasi = Inovasi.find(params[:id])
    @type = 'prepend'
  end

  # GET /kolabs/1/edit
  def edit
    @target = params[:target]
    @inovasi = @kolab.kolabable
    @type = 'replace'
  end

  # POST /kolabs or /kolabs.json
  def create
    @kolab = Kolab.new(kolab_params)
    @opd = Opd.find_by(kode_unik_opd: @kolab.kode_unik_opd)

    # TODO: break the chain
    # this makes unusable outside inovasi
    @inovasi = Inovasi.find(@kolab.kolabable_id)

    if @kolab.save
      render json: { resText: "Kolaborator ditambahkan",
                     html_content: html_content({ kolab: @kolab },
                                                partial: 'kolabs/kolab') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ kolab: @kolab },
                                                 partial: 'kolabs/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /kolabs/1 or /kolabs/1.json
  def update
    if @kolab.update(kolab_params)
      render json: { resText: "Kolaborator ditambahkan",
                     html_content: html_content({ kolab: @kolab },
                                                partial: 'kolabs/kolab') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ kolab: @kolab },
                                                 partial: 'kolabs/form_edit') }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /kolabs/1 or /kolabs/1.json
  def destroy
    @kolab.destroy

    render json: { resText: "Kolaborasi dibatalkan" }.to_json,
           status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_kolab
    @kolab = Kolab.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def kolab_params
    params.require(:kolab).permit(:kolabable_type, :kolabable_id, :jenis,
                                  :kode_unik_opd, :tahun, :status,
                                  :urutan,
                                  :keterangan)
  end
end
