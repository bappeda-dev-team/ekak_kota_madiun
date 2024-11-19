class DomainsController < ApplicationController
  before_action :set_domain, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /domains or /domains.json
  def index
    search = params[:q] || ''
    @domains = Domain.where('domain ILIKE ?', "%#{search}%")
  end

  # GET /domains/1 or /domains/1.json
  def show; end

  # GET /domains/new
  def new
    @domain = Domain.new
  end

  # GET /domains/1/edit
  def edit; end

  # POST /domains or /domains.json
  def create
    @domain = Domain.new(domain_params)

    if @domain.save
      render json: @domain, status: :created
    else
      render json: @domain.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /domains/1 or /domains/1.json
  def update
    if @domain.update(domain_params)
      render json: @domain, status: :ok
    else
      render json: @domain.errors, status: :unprocessable_entity
    end
  end

  # DELETE /domains/1 or /domains/1.json
  def destroy
    @domain.destroy

    respond_to do |format|
      format.html { redirect_to domains_url, warning: "Domain dihapus" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_domain
    @domain = Domain.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def domain_params
    params.require(:domain).permit(:domain, :kode_domain, :keterangan, :tahun)
  end
end
