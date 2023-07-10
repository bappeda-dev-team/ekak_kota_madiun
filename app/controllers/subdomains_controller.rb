class SubdomainsController < ApplicationController
  before_action :set_subdomain, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /subdomains or /subdomains.json
  def index
    @subdomains = Subdomain.all
  end

  # GET /subdomains/1 or /subdomains/1.json
  def show; end

  # GET /subdomains/new
  def new
    @subdomain = Subdomain.new
  end

  # GET /subdomains/1/edit
  def edit; end

  # POST /subdomains or /subdomains.json
  def create
    @subdomain = Subdomain.new(subdomain_params)

    respond_to do |format|
      if @subdomain.save
        format.json { render :show, status: :created, location: @subdomain }
        format.html { redirect_to subdomain_url(@subdomain), notice: "Subdomain was successfully created." }
      else
        format.json { render json: @subdomain.errors, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subdomains/1 or /subdomains/1.json
  def update
    respond_to do |format|
      if @subdomain.update(subdomain_params)
        format.json { render :show, status: :ok, location: @subdomain }
        format.html { redirect_to subdomain_url(@subdomain), notice: "Subdomain was successfully updated." }
      else
        format.json { render json: @subdomain.errors, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subdomains/1 or /subdomains/1.json
  def destroy
    @subdomain.destroy

    respond_to do |format|
      format.html { redirect_to subdomains_url, warning: "Subdomain was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subdomain
    @subdomain = Subdomain.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def subdomain_params
    params.require(:subdomain).permit(:subdomain, :domain_id, :kode_subdomain, :keterangan, :tahun)
  end
end
