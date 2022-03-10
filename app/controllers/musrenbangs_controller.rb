class MusrenbangsController < ApplicationController
  before_action :set_musrenbang,
                only: %i[show edit update destroy aktifkan_usulan non_aktifkan_usulan update_sasaran_asn]

  # GET /musrenbangs or /musrenbangs.json
  def index
    @musrenbangs = Musrenbang.all.order(:created_at)
  end

  def asn_musrenbang
    nip_asn = params[:nip]
    @musrenbangs = Musrenbang.where(nip_asn: nip_asn)
    @musrenbang = Musrenbang.new
  end

  def musrenbang_search
    param = params[:q] || ''
    @musrenbangs = Search::AllUsulan.where(sasaran_id: nil)
                                    .where(
                                      'usulan ILIKE ?', "%#{param}%"
                                    ).includes(:searchable)
                                    .collect(&:searchable)
  end

  def aktifkan_usulan
    respond_to do |format|
      format.js { render :aktifkan_usulan } if @musrenbang.update_attribute(:is_active, 1)
    end
  end

  def non_aktifkan_usulan
    respond_to do |format|
      format.js { render :non_aktifkan_usulan } if @musrenbang.update_attribute(:is_active, 0)
    end
  end

  def update_sasaran_asn
    sasaran = params[:sasaran_id]
    respond_to do |format|
      format.js { render :update_sasaran_asn } if @musrenbang.update_attribute(:sasaran_id, sasaran)
    end
  end

  # GET /musrenbangs/1 or /musrenbangs/1.json
  def show; end

  # GET /musrenbangs/new
  def new
    @musrenbang = Musrenbang.new
  end

  # GET /musrenbangs/1/edit
  def edit; end

  # POST /musrenbangs or /musrenbangs.json
  def create
    @musrenbang = Musrenbang.new(musrenbang_params)

    respond_to do |format|
      if @musrenbang.save
        format.html { redirect_to @musrenbang, notice: 'Musrenbang was successfully created.' }
        format.json { render :show, status: :created, location: @musrenbang }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @musrenbang.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /musrenbangs/1 or /musrenbangs/1.json
  def update
    respond_to do |format|
      if @musrenbang.update(musrenbang_params)
        format.html { redirect_to @musrenbang, notice: 'Musrenbang was successfully updated.' }
        format.json { render :show, status: :ok, location: @musrenbang }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @musrenbang.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /musrenbangs/1 or /musrenbangs/1.json
  def destroy
    @musrenbang.destroy
    respond_to do |format|
      format.html { redirect_to musrenbangs_url, notice: 'Musrenbang was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_musrenbang
    @musrenbang = Musrenbang.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def musrenbang_params
    params.require(:musrenbang).permit!
  end
end
