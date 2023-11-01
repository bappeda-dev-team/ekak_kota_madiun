class ExternalUrlsController < ApplicationController
  before_action :set_external_url, only: %i[ show edit update destroy ]

  # GET /external_urls or /external_urls.json
  def index
    @external_urls = ExternalUrl.all
  end

  # GET /external_urls/1 or /external_urls/1.json
  def show
  end

  # GET /external_urls/new
  def new
    @external_url = ExternalUrl.new
  end

  # GET /external_urls/1/edit
  def edit
  end

  # POST /external_urls or /external_urls.json
  def create
    @external_url = ExternalUrl.new(external_url_params)

    respond_to do |format|
      if @external_url.save
        format.html { redirect_to external_url_url(@external_url), notice: "External url was successfully created." }
        format.json { render :show, status: :created, location: @external_url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @external_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_urls/1 or /external_urls/1.json
  def update
    respond_to do |format|
      if @external_url.update(external_url_params)
        format.html { redirect_to external_url_url(@external_url), notice: "External url was successfully updated." }
        format.json { render :show, status: :ok, location: @external_url }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @external_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_urls/1 or /external_urls/1.json
  def destroy
    @external_url.destroy

    respond_to do |format|
      format.html { redirect_to external_urls_url, notice: "External url was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_url
      @external_url = ExternalUrl.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def external_url_params
      params.require(:external_url).permit(:aplikasi, :endpoint, :username, :password, :keterangan, :kode)
    end
end
