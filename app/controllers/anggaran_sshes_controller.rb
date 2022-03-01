class AnggaranSshesController < ApplicationController
  before_action :set_anggaran_ssh, only: %i[ show edit update destroy ]

  # GET /anggaran_sshes or /anggaran_sshes.json
  def index
    @anggaran_sshes = AnggaranSsh.all
  end

  # GET /anggaran_sshes/1 or /anggaran_sshes/1.json
  def show
  end

  # GET /anggaran_sshes/new
  def new
    @anggaran_ssh = AnggaranSsh.new
  end

  # GET /anggaran_sshes/1/edit
  def edit
  end

  # POST /anggaran_sshes or /anggaran_sshes.json
  def create
    @anggaran_ssh = AnggaranSsh.new(anggaran_ssh_params)

    respond_to do |format|
      if @anggaran_ssh.save
        format.html { redirect_to @anggaran_ssh, notice: "Anggaran ssh was successfully created." }
        format.json { render :show, status: :created, location: @anggaran_ssh }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anggaran_ssh.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anggaran_sshes/1 or /anggaran_sshes/1.json
  def update
    respond_to do |format|
      if @anggaran_ssh.update(anggaran_ssh_params)
        format.html { redirect_to @anggaran_ssh, notice: "Anggaran ssh was successfully updated." }
        format.json { render :show, status: :ok, location: @anggaran_ssh }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anggaran_ssh.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anggaran_sshes/1 or /anggaran_sshes/1.json
  def destroy
    @anggaran_ssh.destroy
    respond_to do |format|
      format.html { redirect_to anggaran_sshes_url, notice: "Anggaran ssh was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_anggaran_ssh
      @anggaran_ssh = AnggaranSsh.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def anggaran_ssh_params
      params.require(:anggaran_ssh).permit(:kode_kelompok_barang, :uraian_kelompok_barang, :kode_barang, :uraian_barang, :spesifikasi, :satuan, :harga_satuan)
    end
end
